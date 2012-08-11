class Admin::Responder < ActionController::Responder
  
   def navigation_location
     follow = options.delete(:action) || (controller.respond_to?(:show) ? :show : :edit)
        
     default_location = if delete?
       {:action => :index}
     elsif (follow.to_sym == :show)
       [:dealers, resource]
     else
        [follow, :admin, resource]
     end
        
     l = options[:location] || default_location
   end
   
   
   # If it's not a get request and the object has no errors, set the flash message
   # according to the current action. If the controller is users/pictures, the
   # flash message lookup for create is:
   #
   #   flash.users.pictures.create
   #   flash.actions.create
   #
   def to_html
     unless get?
       default_success_message = delete? ? I18n.t("flash.success.delete") : I18n.t("flash.success.update")
       default_error_message   = delete? ? I18n.t("flash.error.delete")   : I18n.t("flash.error.update")
       
       if has_errors?
         controller.flash[:error] = options.delete(:error)  || default_error_message 
       else
         controller.flash[:notice] = options.delete(:success) || default_success_message 
       end      
     end
     super
   end

end