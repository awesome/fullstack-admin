module AdminFormHelper
  
  class FormBuilderDecorator
    def initialize(decorated)
       @target = decorated
    end
    
    def method_missing(method, *args, &block)
      @target.send(method, *args, &block)
    end
    
    def actions(*args, &proc)
      @target.template.form_actions(&proc)      
    end
    
    def default_action
      action(@target.object.persisted? ? :update : :create, :primary => true)
    end
    
    def form_errors(options = {:wrap => true})
      wrap = options.delete(:wrap)
      options[:exclude] ||= [:slug]
      f = @target
      unless f.object.errors.empty?
        if wrap
          @target.template.content_tag :div, :class => "alert alert-block" do
            @target.template.link_to "&times;", :class => "close", :data => {:dismiss => "alert"}
            @target.template.content_tag(:h4, I18n.t('fullstack.admin.form.correct_these_errors_and_retry', :default => "Correct these errors and retry"), :class => "alert-heading")
            f.semantic_errors *(f.object.errors.keys - (options[:exclude] || []))
          end
        else
          f.semantic_errors *(f.object.errors.keys - (options[:exclude] || []))
        end
        
      end
    end
    alias :errors :form_errors
    
    def action(method, options = {})
      default_label = I18n.t("fullstack.admin_form.labels.#{method}", :default => "#{method}".humanize)
      options[:type] ||= !!options[:primary] ? :primary : nil
      @target.template.button((options.delete(:label) || default_label), options)
    end


    def resource_inputs(*args)
      model = @target.object.class
      options = args.extract_options!
      
      only_attributes = options[:only] || []
      except_arg = options[:except] || []
      except_attributes = except_arg + model.protected_attributes.to_a + %W(created_at updated_at slug slugs lat lng position)
      
      only_attributes.map! {|a| a.to_s}
      except_attributes.map! {|a| a.to_s}
      
      columns = model.schema.hierarchy_field_names
      
      # ===============
      # = Attachments =
      # ===============
    
      attachment_definitions = (model.attachment_definitions || {}).keys
      attachment_columns = attachment_definitions.map {|a|
        ["#{a}_file_name", "#{a}_file_size", "#{a}_content_type", "#{a}_updated_at"]
        }.flatten
            
      columns -= attachment_columns
      columns += attachment_definitions

          
      # ================
      # = Associations =
      # ================

      columns = columns.map {|field_name|
         field_name.to_s.gsub(/_id$/, "").gsub(/_type$/, "")
      }.uniq
      
      belongs_to_associations = model.reflect_on_all_associations(:belongs_to).select {|a|
        !a.options[:polymorphic] && !a.options[:autosave]
      }.map {|assoc| assoc.name.to_s}
      
      polymorphic_associations = model.reflect_on_all_associations(:belongs_to).select {|a|
        a.options[:polymorphic] && !a.options[:autosave]
      }.map {|assoc| assoc.name.to_s}
      
      autosave_belongs_to     = model.reflect_on_all_associations(:belongs_to).select {|a|
        a.options[:autosave]
      }.map {|assoc| assoc.name.to_s}.compact
    
      has_many_associations = model.reflect_on_all_associations(:has_many).select {|a| 
        a.options[:autosave]
      }.map {|assoc| assoc.name.to_s}
      
      
      
      columns -= polymorphic_associations
      columns += has_many_associations
      
      
      # ====================================
      # = Intersect with :only and :except =
      # ====================================
      
      if only_attributes.any?
        columns = columns.select {|k| only_attributes.include?(k)}
      elsif except_attributes.any?
        columns = columns.delete_if {|k| except_attributes.include?(k)}
      end


      # =============
      # = Rendering =
      # =============
      
      buff = ""
        
      columns.each do |column|
        sym = column.to_sym
        field = model.schema.hierarchy_fields[sym]
        is_belongs_to_associaiton = belongs_to_associations.include?(column)
        is_has_many_association = has_many_associations.include?(column)
        is_autosave_belongs_to = autosave_belongs_to.include?(column)
        
        buff << if is_belongs_to_associaiton
          @target.input(sym, :as => :select)
        
        elsif is_has_many_association || is_autosave_belongs_to
           association_inputs(sym)       

         else
           opts = {}
           args = [sym]
           
           if field && field.options[:markup]
             opts[:as] = :markup

           elsif field && field.options[:in]
             opts[:as] = :select
             opts[:collection] = field.options[:in]
           
           elsif column == "locale"
             opts[:as] = :select
             opts[:collection] = I18n.available_locales.map {|locale| [I18n.t("locale_names.#{locale}", :default => "#{locale}".humanize), locale.to_s] }
             
           else
             nil
           end
           
           args << opts unless opts.empty?
           
           @target.input(*args)

        end
      end
      
      inputs do
        buff.html_safe
      end
    
    end
 
    def resource_submit
       @target.template.button (@target.object.persisted? ? I18n.t('fullstack.admin.update', :default => "Update") : I18n.t('fullstack.admin.create', :default => "Create")),
        :type => :primary, 
        :size => :large
    end
    
    def actions(&block)
      @target.template.form_actions(&block)
    end

    def admin_fields_for(*args)
      @target.semantic_fields_for(*args) do |f|
        yield(FormBuilderDecorator.new(f))
      end
    end
    
    def box(title, options = {})
      options[:orientation] ||= "form-horizontal"
    
        @target.template.content_tag(:div, :class => ("box " << options[:orientation])) do
          buff = ""
          buff << @target.template.content_tag(:div, title, :class => "box-header") 
          buff << @target.template.content_tag(:div, :class => "box-content") do
            yield
          end
          buff.html_safe
        end
    
    end

    
    def sort_association(association, options = {})
       assoc_str = association.to_s
       @target.template.render :partial => "sort", :locals => { 
        :association => association, :f => self, :options => options }
       
    end

    def association_inputs(association, options = {})
      
      assoc_str = association.to_s
      is_singular = assoc_str.pluralize != assoc_str and assoc_str.singularize == assoc_str
      
      if is_singular
        if @target.template.partial?("nested_belongs_to_#{assoc_str}_fields")
          @target.template.render :partial => "nested_belongs_to_#{assoc_str}_fields", :locals => { 
           :association => association, :f => self, :options => options }
        else
          @target.template.render :partial => "nested_belongs_to_fields", :locals => { 
           :association => association, :f => self, :options => options }
        end

      else
        
        if @target.template.partial?("associated_#{assoc_str}_table")
          @target.template.render :partial => "associated_#{assoc_str}_table", :locals => { 
           :association => association, :f => self, :options => options }
        else
          @target.template.render :partial => "associated_resources_table", :locals => { 
           :association => association, :f => self, :options => options }         
        end

      end
 
    end

  end # ~
   
  def admin_form_for(record_or_name_or_array, *args)
    options = args.extract_options!
    options[:builder] ||= FormtasticBootstrap::FormBuilder
    
    semantic_form_for(record_or_name_or_array, *(args << options)) do |f|
      yield(FormBuilderDecorator.new(f))
    end
  end
  
end