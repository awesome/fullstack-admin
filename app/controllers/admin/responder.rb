class Admin::Responder < ActionController::Responder
  
   def navigation_location
     follow = options.delete(:action) || (controller.respond_to?(:show) ? :show : :edit)
        
     default_location = if delete?
       {:action => :index}
     elsif (follow.to_sym == :show)
       [:admin, resource]
     else
        [follow, :admin, resource]
     end
        
     l = options[:location] || default_location
   end
   
   def to_html
     unless get?
       default_success_message = delete? ? I18n.t("fullstack.admin.flash.success.delete") : I18n.t("fullstack.admin.flash.success.update")
       default_error_message   = delete? ? I18n.t("fullstack.admin.flash.error.delete")   : I18n.t("fullstack.admin.flash.error.update")
       
       if has_errors?
         controller.flash[:error] = options.delete(:error)  || default_error_message 
       else
         controller.flash[:notice] = options.delete(:success) || default_success_message 
       end      
     end
     super
   end

end