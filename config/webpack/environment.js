const { environment } = require('@rails/webpacker')
const { resolve } = require('path')

const basePath = resolve(".")

environment.config.set('resolve.mainFields', ['browser', 'main']) // default: ['module', 'main']

// potential approach for webpack 4:
//
// environment.config.set('module.rules', [{
//   test: /@turf\/distance/,
//   resolve: {
//     mainFields: ['browser','main']
//   }
// }])

environment.loaders.append('json', {
  test: /\.(geo)?json$/,
  use: 'json-loader'
})

environment.resolvedModules.prepend('root', basePath + '/node_modules')
module.exports = environment

console.log("basePath", basePath);
console.log("webpack config", environment);
