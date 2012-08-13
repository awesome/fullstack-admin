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
    
  end
   
  def admin_form_for(record_or_name_or_array, *args)
    options = args.extract_options!
    options[:builder] ||= FormtasticBootstrap::FormBuilder
    
    semantic_form_for(record_or_name_or_array, *(args << options)) do |f|
      yield(FormBuilderDecorator.new(f))
    end
  end
  
end