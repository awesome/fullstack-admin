#= require limit
#= require combobox
#= require jquery.tagsinput
#= require prevent_submit_on_enter
#= require slider_input
#= require bootstrap-wysihtml5-all
#= require support/pickers
#= require chosen-jquery
#= require ajax-chosen
#= require jquery.remotipart
#= require jquery.validate
#= require ckeditor/init
#= require support/nested_forms
#= require support/file_input

## require jquery.form


$(document).ready ->

  $("input[data-limit],textarea[data-limit]").limit()
  $("select:not([data-remote]):not(.datetime-selector)").chosen()

  $("select[data-remote]").each ->
    $(this).ajaxChosen {method: "GET", url:$(this).data('remote'), dataType: 'json'}, (data) ->
      data

  # $("select:not([data-remote]):not(.datetime-selector)").select2()
  # 
  # $("select[data-remote]").each ->    
  #   $(@).select2
  #     placeholder: $(@).data('placeholder')
  #     minimumInputLength: 3
  #     ajax:
  #       url: $(@).data('remote')
  #       dataType: "json"
  #       data: (term) ->
  #         q: term
  # 
  #       results: (data) -> 
  #         results: data

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

  $("textarea.markup").wysihtml5
    'font-styles' : false
    emphasis: true
    lists: false
    html: false
    link: false
    image: false

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

  # ============
  # = CKEditor =
  # ============
  $( '.markup-ckeditor' ).each ->
      CKEDITOR.replace( $(this).attr('id') );
    