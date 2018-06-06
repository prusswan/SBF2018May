const { environment } = require('@rails/webpacker')

const distance = require('@turf/distance');

global.explode = require('@turf/explode');

environment.loaders.append('json', {
  test: /\.(geo)?json$/,
  use: 'json-loader'
})

module.exports = environment
