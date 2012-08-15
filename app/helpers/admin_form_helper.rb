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


    def resource_inputs(res, *args)
      model = res.class
      options = args.extract_options!
      
      only_attributes = options[:only] || []
      except_attributes = options[:except] || model.protected_attributes.to_a + %W(created_at updated_at slug slugs lat lng)
      
      only_attributes.map! {|a| :"#{a}"}
      except_attributes.map! {|a| :"#{a}"}
              
      columns = model.attribute_names.map! {|a| :"#{a}"}
      
      if only_attributes.any?
        columns = columns.select {|k| only_attributes.include?(k)}
      elsif except_attributes.any?
        columns = columns.delete_if {|k| except_attributes.include?(k)}
      end


      buff = ""
      
      columns.each {|k|
        k = "#{k}".gsub(/_ids?$/, "").to_sym
        assoc = model.reflect_on_association(k) 
        if assoc && assoc.belongs_to?
          buff << @target.input(k, :as => :select)
        else
          buff << @target.input(k)
        end
        
      }
      
      buff.html_safe
    end
 
    def resource_submit(res)
       @target.template.button (res.persisted? ? I18n.t('fullstack.admin.update', :default => "Update") : I18n.t('fullstack.admin.create', :default => "Create")),
        :type => :primary, 
        :size => :large
    end
    
    def actions(&block)
      @target.template.form_actions(&block)
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