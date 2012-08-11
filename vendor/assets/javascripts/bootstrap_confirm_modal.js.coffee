bootStrapConfirmModal = (message, element) ->
  d = $("#modal-confirm")
  $("#modal-confirm div.modal-body p").html message
  $("#modal-confirm #modal-accept").click (e) ->
    d.modal "hide"
    $.rails.handleLink element
    false
  d.modal()

$(document).ready ->
  $("body").append "<div id=\"modal-confirm\" class=\"modal modal-dialog hide fade\"><div class=\"modal-header\"><a href=\"#\" class=\"close\" data-dismiss=\"modal\">×</a><h3>Conferma</h3></div><div class=\"modal-body\"><p class=\"confirm-message\"></p></div><div class=\"modal-footer\"><a href=\"#\" class=\"btn\" data-dismiss=\"modal\">Annulla</a><a href=\"#\" class=\"btn btn-primary\" id=\"modal-accept\">Ok</a></div></div>"  if $("#rails-confirm-modal").length is 0
  $.rails.confirm = (message, element) ->
    bootStrapConfirmModal message, element

  $.rails.allowAction = (element) ->
    message = element.data("confirm")
    answer = false
    callback = undefined
    return true  unless message
    if $.rails.fire(element, "confirm")
      answer = $.rails.confirm(message, element)
      callback = $.rails.fire(element, "confirm:complete", [ answer ])
    answer and callback

  $.rails.handleLink = (link) ->
    if link.data("remote") isnt `undefined`
      $.rails.handleRemote link
    else $.rails.handleMethod link  if link.data("method")
    false
