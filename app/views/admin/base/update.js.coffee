<% if instance_variable_get("@#{controller_name.singularize}").errors.empty? %>
notify_notice('<%=j t("fullstack.admin.flash.success.update") %>')
<% else %>
notify_error('<%=j t("fullstack.admin.flash.error.update")  %>')
<% end %>