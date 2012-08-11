$(document).ready ->
  $("input.pick_one").each ->
    input = $ @
    display = $ "<div class=\"display\" />"
    input.after(display)
    
    resource   = input.data("resource")
    controller = input.data("controller")
    renderer   = [controller, "display"].join("/")
    picker     = [controller, "pick"].join("/")

    current_id = input.val
    if current_id
      display.load()