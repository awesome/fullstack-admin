class Admin::ScaffoldController < Admin::BaseController
  respond_to :html, :js
  before_filter :prepend_resource_views_prefix
    
  def index
    @search = current_resource_class.search(params[:search])
    set_collection @search.page(params[:page] || 1)
  end

  def new
     set_object current_resource_class.new  
  end
  
  def edit
  end
  
  def create
      set_object current_resource_class.new(params[:"#{resource_name}"])
      
      if current_resource.respond_to?("administrator=")
        current_resource.administrator ||= current_administrator
      end
      
      current_resource.save
      respond_with(current_resource)
  end
  
  def update
    current_resource.attributes = params[:"#{resource_name}"]
    current_resource.save
    respond_with(current_resource)
  end
  
  def destroy
    current_resource.destroy
    respond_with(current_resource)
  end
  
  protected
  
  # overrides checkin default
  def fetch_object
    if params[:id]
      set_object(current_resource_class.find(params[:id]))
    end
  end
    
  # helpers overrides
  def current_resource_class
    @current_resource_class ||= params[:_admin_resource_type].classify.constantize
  end

  private 

  def prepend_resource_views_prefix
    lookup_context.prefixes.unshift "admin/#{collection_name}"
  end

  def set_object(value)
    instance_variable_set("@#{resource_name}", value)    
  end
  
  def set_collection(value)
    instance_variable_set("@#{collection_name}", value)
  end
  
  
end
