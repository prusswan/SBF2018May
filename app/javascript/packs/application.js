/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

console.log('Hello World from Webpacker');

if (!("pathFinder" in window)) {
  console.log("pathfinder");

  window.PathFinder = require('geojson-path-finder');
  window.roadLines = require('RoadSectionLine.geojson');
  window.pathFinder = new PathFinder(roadLines, {precision: 1e-3});


  // test:
  // pathFinder.findPath({geometry:{coordinates:[103.874, 1.348]}},{geometry:{coordinates:[103.873, 1.349]}})
}
