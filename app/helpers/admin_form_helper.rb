module AdminFormHelper
  
  class FormBuilderDecorator
    def initialize(decorated)
       @target = decorated
    end
    
    def errors(*args)
      @target.template.form_errors(@target, *args)
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
      f = this
      unless f.object.errors.empty?
        content_tag :div, :class => "alert alert-block" do
          link_to "&times;", :class => "close", :data => {:dismiss => "alert"}
          content_tag(:h4, t('fullstack.admin.form.correct_these_errors_and_retry', :default => "Correct these errors and retry"), :class => "alert-heading")
          f.semantic_errors *(f.object.errors.keys - (options[:exclude] || []))
        end
      end
    end
    
    def action(method, options = {})
      default_label = I18n.t("fullstack.admin_form.labels.#{method}", :default => "#{method}".humanize)
      options[:type] ||= !!options[:primary] ? :primary : nil
      @target.template.button((options.delete(:label) || default_label), options)
    end

  end
  
  def after_current_form(key = :default, options = {:replace => false})
    reset_after_current_form_hash! if @after_current_form.nil?
    if options[:replace]
      @after_current_form[key] = ""
    end
    
    @after_current_form[key]
  end
  
  def reset_after_current_form_hash!
    @after_current_form = ActiveSupport::OrderedHash.new
    @after_current_form[:default] = ""
  end
  
  def admin_form_for(record_or_name_or_array, *args)
     semantic_form_for(record_or_name_or_array, *args) do |f|
       yield(FormBuilderDecorator.new(f)) << @after_current_form.map { |k, v| v }.join().html_safe
     end
  end
  
end