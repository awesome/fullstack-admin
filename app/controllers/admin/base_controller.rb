class Admin::BaseController < ApplicationController
  rescue_from Checkin::AccessDenied, :with => :rescue_access_denied

  layout 'admin'
  authorize(:scope => :admin)

  protected

  def rescue_access_denied
    if subject.guest?
      redirect_to new_user_session_path
    else
      render :text => "Not Authorized", :status => 403
    end
  end
  
  class << self
    def responder
    ::Admin::Responder
    end
  end
  
  helper_method :singular_name,
                :plural_name,
                :resource_name,
                :collection_name,
                :current_resource_class,
                :current_resource, 
                :current_collection,
                :title_column


  def current_resource_class
    @current_resource_class ||= controller_name.singularize.camelize.constantize
  end
  
  def resource_name
    current_resource_class.name.demodulize.underscore
  end
  
  def collection_name
    resource_name.pluralize
  end

  alias :singular_name :resource_name
  alias :plural_name :collection_name
  

  def current_resource
    instance_variable_get("@#{resource_name}")
  end

  def current_collection
    instance_variable_get("@#{collection_name}")
  end
  
  def title_column(model)
    @_title_columns ||= {}
    @_title_columns[model] ||= ( model.column_names.map{ |c| c.to_s } & %W(title name label browser_title seo_title seo_name key claim email) ).first
  end
  
  
end
