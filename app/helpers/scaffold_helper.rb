module ScaffoldHelper
    def default_collection_actions_for(content, scope = :admin)
      buttons = []

      if subject.can_show?(content) && lookup_context.exists?('show', lookup_context.prefixes, false)
        buttons << link_to(t('fullstack.admin.show', :default => "Show"), self.send(:"#{scope}_#{resource_name}_path", content), :class => "btn")
      end

      if subject.can_edit?(content)
        buttons << link_to(t('fullstack.admin.edit', :default => "Edit"), self.send(:"edit_#{scope}_#{resource_name}_path", content), :class => "btn")
      end

      if subject.can_destroy?(content)
        buttons << link_to(t('fullstack.admin.delete', :default => "Delete"),
                self.send(:"#{scope}_#{resource_name}_path", content),
                :confirm => t('fullstack.admin.are_you_sure', :default => "Are you sure?"), :method => "delete",
                :remote => true,  :class => "btn hide btn-danger"
                )
      end
      "#{buttons.join('&nbsp;')}".html_safe
    end

    def labelize_attribute_name(method)
    method ||= "id" 
         I18n.t("helpers.label.#{method}", :default => method.to_s.humanize)
    end

    def sort_link(method)
      method = "#{method}"
      super(@search, method, labelize_attribute_name(method))
    end
    
    def app_name
      Rails.application.class.to_s.split("::").first.underscore.humanize
    end
    
    def has_timestamps?(model)
      model.columns_hash["created_at"]
    end

    def has_locale?(model)
      model.columns_hash["locale"]
    end
        
    def positionable?(object_or_class)
      model = object_or_class.is_a?(Class) ? object_or_class : object_or_class.class
      model.ancestors.include?(Positionable)
    end
    
    def skip_filter!
      @skip_filter = true
    end
    
    def skip_filter
      @skip_filter
    end
    
end