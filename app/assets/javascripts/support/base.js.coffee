#= require jquery
#= require jquery_ujs
#= require jquery-ui
#= require notify
#= require jquery.sticky

  
fixHelper = (e, ui) ->
  ui.children().each ->
    self = $ @
    self.width self.width()
  ui


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

  $("tbody.sortable").sortable({ axis: 'y', items: 'tr', helper: fixHelper,  handle: '.handle'  })
  $("ul.sortable").sortable({ items: 'li', helper: fixHelper  })

  $("a[rel=facebox]").facebox()
  $("[data-tip]").tooltip({
      title: ->
        $(@).data('tip')
  })
  
  

  
    
