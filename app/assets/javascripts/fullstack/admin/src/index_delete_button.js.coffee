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
