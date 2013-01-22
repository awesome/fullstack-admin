$(document).ready ->
  $("input[type='text']").keydown (event) ->
    if event.keyCode is 13
      event.preventDefault()
      false
