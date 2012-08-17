#= require jquery
#= require jquery_ujs
#= require jquery-ui
#= require notify
#= require jquery.sticky

$(document).ready ->
  $(".btn.toggle-delete").on "click", (e) ->
    button = $(this)
    links = $("[data-method='delete']")
    if button.hasClass("showing")
      links.hide "fast"
      button.removeClass "showing"
    else
      links.show "fast"
      button.addClass "showing"

fixHelper = (e, ui) ->
  ui.children().each ->
    self = $ @
    self.width self.width()
  ui
  
$("tbody.sortable").sortable({ axis: 'y', items: 'tr', helper: fixHelper,  handle: '.handle'  })

    
