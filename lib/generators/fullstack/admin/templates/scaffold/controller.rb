class <%= scope_class %>::<%= controller_class_name %>Controller < <%= scope_class %>::BaseController
  respond_to :html, :js
  
  def index
    @search = <%= resource_class_name %>.search(params[:search])
    @<%= collection_name %> = @search.page(params[:page] || 1)
  end

  def new
    <%- if content? -%>
    @<%= resource_name %> = <%= resource_class_name %>.new(:author_id => current_user._id)
    <%- else -%>
    @<%= resource_name %> = <%= resource_class_name %>.new  
    <%- end -%>
  end
  
  def edit
  end
  
  def create
      @<%= resource_name %> = <%= resource_class_name %>.new(params[:<%= resource_name %>])
      
      if @<%= resource_name %>.respond_to?(:author)
        @<%= resource_name %>.author ||= current_user
      end
      
      @<%= resource_name %>.save
      respond_with(@<%= resource_name %>)
  end

  def update
    @<%= resource_name %>.attributes = params[:<%= resource_name %>]
    @<%= resource_name %>.save
    respond_with(@<%= resource_name %>)
  end

  def destroy
    @<%= resource_name %>.destroy
    respond_with(@<%= resource_name %>)
  end
end


