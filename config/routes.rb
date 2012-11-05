Rails.application.routes.draw do
 
  mount Ckeditor::Engine => '/ckeditor'
  
  namespace :admin do
    resources :sessions, :only => [:new, :create] do
      match :destroy, :via => :delete, :on => :collection
    end
    
    resources :positionables, :only => [:index] do
      post :sort, :on => :collection
    end
    
    Fullstack::Admin.resources.each do |r|
      if r.type == :resource
        if "Admin::#{r.name.to_s.pluralize.camelize}Controller".safe_constantize
          resources r.name, :except => [:show]    
        else
          resources r.name, :except => [:show], :controller => :scaffold, :_admin_resource_type => r.name
        end
      end
    end
    
  end
  
end