$(document).ready ->
  $(".file-input-choose-file-button").live "click", ->
    self = $(@)
    
    if self.hasClass("disabled")
      return 0
    
    file_input = self.find("~ input[type='file']")
    file_name_span = self.closest(".controls").find(".file-input-attachment-filename")
     
    file_input.change ->
      file_input_val = file_input.val()
      file_name      = file_input_val.substring(file_input_val.lastIndexOf('/') + 1).substring(file_input_val.lastIndexOf('\\') + 1)
      file_name_span.text(file_name)

    file_input.click()
    
  $(".file-input-delete-attachment-button").live "click", ->
    
    btn = $(@)
    input_container = btn.closest(".controls")
    
    if btn.hasClass("active")
      input_container.find(".btn:not(.file-input-delete-attachment-button)").addClass("disabled")
      btn.siblings(".file-input-attachment-filename").css({"text-decoration": "line-through", opacity: 0.5})
      btn.find("~ .file-input-delete-attachment-checkbox").attr('checked', true);
    else
      input_container.find(".btn:not(.file-input-delete-attachment-button)").removeClass("disabled")
      btn.siblings(".file-input-attachment-filename").css({"text-decoration": "none", opacity: 1})
      btn.find("~ .file-input-delete-attachment-checkbox").attr('checked', false);
      