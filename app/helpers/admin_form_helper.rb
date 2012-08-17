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
    
    def form_errors(options = {:exclude => [:slug]})
      f = @target
      unless f.object.errors.empty?
        @target.template.content_tag :div, :class => "alert alert-block" do
          @target.template.link_to "&times;", :class => "close", :data => {:dismiss => "alert"}
          @target.template.content_tag(:h4, I18n.t('fullstack.admin.form.correct_these_errors_and_retry', :default => "Correct these errors and retry"), :class => "alert-heading")
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
      
      except_attributes = options[:except] || model.protected_attributes.to_a + %W(created_at updated_at slug slugs lat lng position)
      
      only_attributes.map! {|a| :"#{a}"}
      except_attributes.map! {|a| :"#{a}"}
              
      columns = model.attribute_names.map! {|a| :"#{a}"}
      
      if only_attributes.any?
        columns = columns.select {|k| only_attributes.include?(k)}
      elsif except_attributes.any?
        columns = columns.delete_if {|k| except_attributes.include?(k)}
      end


      buff = ""
      
      attachment_definitions = (model.attachment_definitions || {}).keys
      attachment_columns = attachment_definitions.map {|a|
        [:"#{a}_file_name", :"#{a}_file_size", :"#{a}_content_type", :"#{a}_updated_at"]
        }.flatten
      
      columns -= attachment_columns
      columns += attachment_definitions
            
      
      columns.each {|k|
        k = "#{k}".gsub(/_ids?$/, "").gsub(/_type$/, "").to_sym
        assoc = model.reflect_on_association(k) 
        if assoc && assoc.belongs_to?
          unless assoc.options[:polymorphic]
            buff << @target.input(k, :as => :select)
          end
        else
          buff << @target.input(k)
        end
        
      }
      
      buff.html_safe
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
      @target.template.content_tag :div,:class => "well" do
      admin_fields_for(association) do |f|
        
        partial_name = association.to_s.singularize + "_fields"
        
        if @target.template.partial?(partial_name)
           @target.template.render(:partial => partial_name, :f => f)
        else
          f.resource_inputs
        end
      
      end
      end
    end

    # def link_to_remove_fields(name)
    #   @target.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
    # end
    #   
    # def link_to_add_fields(name, association)
    #   new_object = @target.object.class.reflect_on_association(association).klass.new
    #   
    #   partial_name = association.to_s.singularize + "_fields"
    #   fields = admin_fields_for(association, new_object, :child_index => "new_#{association}") do |builder|        
    #     
    #   end
    #   @target.template.link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
    # end


  end # ~
   
  def admin_form_for(record_or_name_or_array, *args)
    options = args.extract_options!
    options[:builder] ||= FormtasticBootstrap::FormBuilder
    
    semantic_form_for(record_or_name_or_array, *(args << options)) do |f|
      yield(FormBuilderDecorator.new(f))
    end
  end
  
end