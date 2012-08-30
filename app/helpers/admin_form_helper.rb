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
      
      only_attributes.map! {|a| :"#{a}"}
      except_attributes.map! {|a| :"#{a}"}
              
      columns = model.schema.hierarchy_field_names.map! {|a| :"#{a}"}
    
      attachment_definitions = (model.attachment_definitions || {}).keys
      attachment_columns = attachment_definitions.map {|a|
        [:"#{a}_file_name", :"#{a}_file_size", :"#{a}_content_type", :"#{a}_updated_at"]
        }.flatten
      
      columns -= attachment_columns
      columns += attachment_definitions
      
      if only_attributes.any?
        columns = columns.select {|k| only_attributes.include?(k)}
      elsif except_attributes.any?
        columns = columns.delete_if {|k| except_attributes.include?(k)}
      end

      buff = ""
        
      columns.each {|k|
        k = "#{k}".gsub(/_ids?$/, "").gsub(/_type$/, "").to_sym
        assoc = model.reflect_on_association(k) 
        if assoc && assoc.belongs_to?
          unless assoc.options[:polymorphic]
            buff << @target.input(k, :as => :select)
          end
        else
          
          if field = model.schema.hierarchy_fields[k]
            if field.options[:markup]
              buff << @target.input(k, :as => :markup)
            elsif field.options[:simple_markup]
              buff << @target.input(k, :as => :simple_markup)
            else
              buff << @target.input(k)
            end
          else 
            buff << @target.input(k)          
          end
          
        end
        
      }
      
      buff = self.inputs do
        buff.html_safe
      end
      
      model.reflect_on_all_associations(:has_many).select {|m| m.options[:autosave] }.each do |assoc|
        buff << association_inputs(assoc.name)
      end
      
      buff
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

    def association_inputs(association)
       @target.template.render :partial => "associated_resources_table", :locals => { 
        :association => association, :f => self } 
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