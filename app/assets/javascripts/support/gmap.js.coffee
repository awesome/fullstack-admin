#= require jquery.ui.map

$(document).ready ->
  $(".gmap").each ->
    canvas = $(this)
    markers = []
    canvas.find(".marker").each ->
      marker_elem = $(this)
      marker = {}
      marker.position = marker_elem.data("position")
      marker.title  = marker_elem.data("title")
      marker_elem.remove()
      markers.push(marker)

    map = canvas.gmap
      center: canvas.data("center")
      zoom: canvas.data("zoom")
      disableDefaultUI:true

    map.bind 'init', ->
      $.each markers, (i, marker) ->
        canvas.gmap('addMarker', {position: marker.position, bounds:false, title: marker.title})
