// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
//
// window.showMap = (bounds, geoJSON) ->
//   L.mapbox.accessToken = 'pk.eyJ1IjoiY29ycmVjdGVkdGltZSIsImEiOiJjaWg0MWRmenowMHZqdmZrcnF3ZjIwaG0xIn0.Sc5PjkciWsrAV88InaZLkQ';
//   map = L.mapbox.map('map', 'mapbox.streets');
//
//   map.fitBounds(bounds);
//   L.control.fullscreen().addTo(map);
//   L.polyline(geoJSON, {color: 'red'}).addTo(map)

window.showMap = function(bounds, geoJSON) {
  var map;
  L.mapbox.accessToken = 'pk.eyJ1IjoiY29ycmVjdGVkdGltZSIsImEiOiJjaWg0MWRmenowMHZqdmZrcnF3ZjIwaG0xIn0.Sc5PjkciWsrAV88InaZLkQ';
  map = L.mapbox.map('map', 'mapbox.streets');
  map.fitBounds(bounds);
  L.control.fullscreen().addTo(map);
  return L.polyline(geoJSON, {
    color: 'red'
  }).addTo(map);
};

function setCookie(key, value) {
  var expires = new Date();
  expires.setTime(expires.getTime() + (1 * 24 * 60 * 60 * 1000));
  document.cookie = key + '=' + value + ';expires=' + expires.toUTCString();
}

$(function(){
  $('#km-select').on('change', function () {
    setCookie('units', 'km');
    document.location.reload();
  })

  $('#miles-select').on('change', function () {
    setCookie('units', 'miles');
    document.location.reload();
  })
});
