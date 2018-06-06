/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

console.log('Hello World from Webpacker');


//(() => {
  const distance = require('@turf/distance');
  // const explode = require('@turf/explode');
  import explode from '@turf/explode';

  if (!("pathFinder" in window)) {
    console.log("pathfinder");

    var PathFinder = require('geojson-path-finder');
    var geojson = require('RoadSectionLine.geojson');
    console.log(explode);
    window.pathFinder = new PathFinder(geojson);
  }
//})()
