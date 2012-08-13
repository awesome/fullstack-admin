module ResourcesHelper

  def singular_name
    controller_name.singularize
  end
  alias :resource_name :singular_name

  def plural_name
    controller_name
  end
  alias :collection_name :plural_name

  def current_resource
    instance_variable_get("@#{resource_name}")
  end

  def current_collection
    instance_variable_get("@#{collection_name}")
  end
  
end