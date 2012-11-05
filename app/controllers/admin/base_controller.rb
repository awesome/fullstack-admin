class Admin::BaseController < ApplicationController
  before_filter :require_login
  before_filter :fetch_current_resource
  
  layout 'admin'

  protected

  def not_authenticated
    redirect_to new_admin_session_url, :alert => "First login to access this page."
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
                :title_column,
                :subject


  def subject
    @subject ||= ::Admin::SubjectModelAdapter.new(current_user)
  end

  def current_resource_class
    @current_resource_class ||= controller_name.singularize.camelize.constantize rescue nil
  end
  
  def resource_name
    current_resource_class && current_resource_class.name.demodulize.underscore
  end
  
  def collection_name
    resource_name.try(:pluralize)
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
  
  def fetch_current_resource
    return if !params[:id] || current_resource 
    instance_variable_set("@#{resource_name}", current_resource_class.find(params[:id]))
  end
  
end