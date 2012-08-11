module ScaffoldHelper
    def default_collection_actions_for(content, scope = :admin)
      buttons = []

      if subject.can_show?(content) && lookup_context.exists?('show', lookup_context.prefixes, false)
        buttons << link_to(t('fullstack.admin.show', :default => "Show"), self.send(:"#{scope}_#{controller_name.singularize}_path", content), :class => "btn")
      end

      if subject.can_edit?(content)
        buttons << link_to(t('fullstack.admin.edit', :default => "Edit"), self.send(:"edit_#{scope}_#{controller_name.singularize}_path", content), :class => "btn")
      end

      if subject.can_destroy?(content)
        buttons << link_to(t('fullstack.admin.delete', :default => "Delete"),
                self.send(:"#{scope}_#{controller_name.singularize}_path", content),
                :confirm => t('fullstack.admin.are_you_sure', :default => "Are you sure?"), :method => "delete",
                :remote => true,  :class => "btn hide btn-danger"

                )
      end
      "#{buttons.join('&nbsp;')}".html_safe
    end

    def sort_link(method)
      method = "#{method}"
      super(@search, method, I18n.t(method, :scope => 'fullstack.admin.form.labels', :default => method.humanize))
    end

end
