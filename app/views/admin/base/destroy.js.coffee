<% if instance_variable_get("@#{controller_name.singularize}").destroyed? %>
$("a[data-method='delete']").filter("[href='<%=j request.path %>']").closest("tr, li").remove()
notify_notice('<%=j t("flash.success.delete")  %>')
<% else %>
notify_error('<%=j t("flash.error.delete")  %>')
<% end %>

