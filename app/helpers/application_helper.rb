module ApplicationHelper

  def get_data(data_type='BusStops')
    data = []
    data_file = "public/#{data_type}_all.json"

    if File.exist? data_file
      data = JSON.parse(File.read(data_file))
    else
      offset = 0

      loop do
        result = get_data_from_api(data_type, offset)
        data += result
        break if result.length < 500
        offset += 500
      end

      File.open(data_file,"w") do |f|
        f.write(data.to_json)
        p "#{data_file} downloaded"
      end
    end

    data
  end

  def get_data_from_api(data_type='BusStops', offset=0)
    url = URI("http://datamall2.mytransport.sg/ltaodataservice/#{data_type}?$skip=#{offset}")

    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Get.new(url)
    request["AccountKey"] = ENV['DATAMALL_KEY']
    request["accept"] = 'application/json'
    # request["Authorization"] = 'Bearer AAAAAAAAAAAAAAAAAAAAAEMALAAAAAAApCSCNq6dqEuCeSVr9l9mh7yGeAQ%3DV8xOltRxERzzvv14h7qkR4muDZ6qFJICAfvcYHAQRUwd8INBoS'
    request["Cache-Control"] = 'no-cache'
    # request["Postman-Token"] = 'dec6dd3e-32a7-404a-8ec7-17b6998627bb'

    response = http.request(request)
    result = JSON.parse response.read_body
    result['value']
  end

  def write_stops_geojson
    stops = get_data('BusStops')
    routes = get_data('BusRoutes')
    stop_services = routes.group_by {|r| r['BusStopCode'] }

    entity_factory = RGeo::GeoJSON::EntityFactory.instance
    factory = RGeo::Geographic.simple_mercator_factory

    result = stops.map.with_index do |s, i|
      stop_code = s['BusStopCode']
      s['BusServices'] = stop_services[stop_code].map {|c| c['ServiceNo']}.uniq.sort_by(&:to_i)
      s['BusRoutes'] = stop_services[stop_code].map {|c| [c['ServiceNo'], c['Direction']] }
        .uniq.map{|u| "#{u.first}-#{u.last}" }
      entity_factory.feature(factory.point(s['Longitude'], s['Latitude']), s['BusStopCode'], s)
    end

    geojson_file = "public/busstops_all.geojson"
    File.open(geojson_file,"w") do |f|
      json = RGeo::GeoJSON.encode(entity_factory.feature_collection(result)).to_json
      f.write(json)
    end

    result
  end

  def write_services_geojson
    stops = get_data('BusStops')
    routes = get_data('BusRoutes')
    services = get_data('BusServices')
    stop_points = stops.group_by {|r| r['BusStopCode'] }
    srv_routes = routes.group_by {|r| [r['ServiceNo'], r['Direction']] }
    srv_info = services.group_by {|r| [r['ServiceNo'], r['Direction']] }

    entity_factory = RGeo::GeoJSON::EntityFactory.instance
    factory = RGeo::Geographic.simple_mercator_factory

    result = srv_routes.map.with_index do |r, i|
      srv_code, dir = r[0][0], r[0][1]

      path_nodes = r[1].sort_by{|n| n['StopSequence']}
        .reject {|b| stop_points[b['BusStopCode']].nil?}
        .map do |m|
          stop_points[m['BusStopCode']].first
        end
        .map do |s|
          factory.point(s['Longitude'], s['Latitude'])
        end

      line = factory.line_string(path_nodes)
      prop = srv_info[r[0]].first
      entity_factory.feature(line, "#{srv_code}-#{dir}", prop)
    end

    geojson_file = "public/busservices_all.geojson"
    File.open(geojson_file,"w") do |f|
      json = RGeo::GeoJSON.encode(entity_factory.feature_collection(result)).to_json
      f.write(json)
    end

    result
  end
end
