fixHelper = (e, ui) ->
  ui.children().each ->
    self = $ @
    self.width self.width()
  ui

$(document).ready ->
  $("tbody.sortable").sortable({ axis: 'y', items: 'tr', helper: fixHelper,  handle: '.handle'  })
  $("ul.sortable").sortable({ items: 'li', helper: fixHelper  })
