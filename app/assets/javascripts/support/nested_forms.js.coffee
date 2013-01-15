$(document).ready ->
  $('a.btn-delete-associated-resource').live 'click', ->
    self = $(@)
    associated_resource = $(@).closest(".associated-resource")
    
    if !self.hasClass("active")
      associated_resource.removeClass("deleted");
      associated_resource.find("input.destroy-associated-resource").val('0')
    else
      associated_resource.addClass("deleted");
      associated_resource.find("input.destroy-associated-resource").val('1')

  autoupdate_labels = (associated_resources) ->
    associated_resources.each ->
      associated_resource = $(@)
      
      label_input = $(associated_resource.find("input[type='text']")[0])
      console.log(label_input)
      label_input.change ->
        associated_resource.find(".associated-resource-label").text(label_input.val())
  
  update_positions = (sortable) ->
    sortable.find('input.associated-resource-position').each (i, e) ->
      $(@).val(i)

  $(".btn-add-associated-resource").click ->
    associated_resources        = $(@).closest(".associated-resources")
    associated_resources_index  = associated_resources.find(".associated-resources-index")
    resource_fields_template    = associated_resources.find(".resource-fields-template")
    new_id = new Date().getTime()
    template_instance           = $(resource_fields_template.html().replace(/___index___/g, new_id))
    associated_resources_index.append(template_instance)
    autoupdate_labels(associated_resources_index.find('.associated-resource:last'))
    update_positions associated_resources_index
    associated_resources_index.find('.associated-resource:last').find(".btn[data-toggle='modal']").click()
  
  autoupdate_labels($('.associated-resource'))
  
  $('.positionable .sortable').live 'sortupdate', ->
    update_positions $(@)