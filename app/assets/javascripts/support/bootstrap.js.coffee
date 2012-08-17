#= require bootstrap

$(document).ready ->
  
  $(".modal-dialog").modal({backdrop: true, keyboard: true, show: false, static: false})
  $("[data-tip]").tooltip title: (e) ->
    $(this).data "tip"

  $(".btn.disabled").on "click", (e) ->
    e.stopPropagation()
    false

  ($ "a[data-toggle=modal]").live 'click', ->
    target = ($ @).attr('data-target')
    url = ($ @).attr('href')
    if url != "#"
      ($ target).load(url)


  $("[data-dismiss='modal']").live 'click', ->
    ($ @).closest('.modal').modal('hide')

  $("[data-toggle='popover']").popover()
  
  $('.carousel').carousel()