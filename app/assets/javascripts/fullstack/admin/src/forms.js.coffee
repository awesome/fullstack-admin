#= require chosen-jquery
#= require jquery.remotipart
#= require fullstack/ckeditor

$(document).ready ->

  $("select:not([data-remote]):not(.datetime-selector)").chosen()
  $("select[data-remote]").each ->
    $(this).ajaxChosen {method: "GET", url:$(this).data('remote'), dataType: 'json'}, (data) ->
      data

  $("input.taglist").each ->
    taglist = $(this)
    autocomplete_url = taglist.data("autocomplete")
    defaultText = taglist.data("text") || "Add tag"
    taglist.tagsInput
      autocomplete_url: autocomplete_url
      autocomplete: { minLength: 3 },
      defaultText: defaultText, 
      minChars: 3

  $('input.slider').sliderInput()

  $(".on-focus-help").each ->
    self = $(this)
    input = self.parent().find("input")
    input.focus(->
      self.show "fast"
    ).blur ->
      self.hide "fast"
      
  $('input.datepicker').each (i, e) ->
    display = $(this)
    name = display.attr("name")
    display.removeAttr("name")

    input = $("<input name='#{name}' type='hidden' />")
    display.before(input)

    display.datepicker
      altField: input
      altFormat: "yy-mm-dd"
      dateFormat: "d M yy"
      beforeShow: ->
        setTimeout( ( -> $('.ui-datepicker').css("z-index", 9999) ),100);


    if !!display.val()
      display.datepicker("setDate", new Date(display.val()))

    close = $("<a class='close datepicker-cancel'>&times;</a>")
    close.click ->
      display.datepicker("setDate", null)
    display.after(close)