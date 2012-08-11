#= require jquery.facebox

$(document).ready ->

  $("img[data-zoom-url]").live 'click', ->
    jQuery.facebox({ image: ($ @).data('zoom-url') })
