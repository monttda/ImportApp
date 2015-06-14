<% @operations_by_company.each do |operation|%>
  $("#<%=@table_id%>").find('tbody').append("<%= j(render 'operations', operation: operation, categories: @formatted_categories_per_operation[operation.id]) %>")
<% end %>
  $("#<%=@table_id%>").data('nextpage',"<%=@next_page%>")
<% unless @more_to_show %>
  $("#<%=@table_id%>").closest('.panel-body').find('.more_operations').addClass('hidden')
<% end %>
