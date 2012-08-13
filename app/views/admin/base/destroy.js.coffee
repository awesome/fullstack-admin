<% if instance_variable_get("@#{controller_name.singularize}").destroyed? %>
$("a[data-method='delete']").filter("[href='<%=j request.path %>']").closest("tr, li").remove()
notify_notice('<%=j t("fullstack.admin.flash.success.delete")  %>')
<% else %>
notify_error('<%=j t("fullstack.admin.flash.error.delete")  %>')
<% end %>

