class BooleanInput
  include Formtastic::Inputs::Base
  include FormtasticBootstrap::Inputs::Base::Labelling
  include FormtasticBootstrap::Inputs::Base::Wrapping
  include FormtasticBootstrap::Inputs::Base::Errors
  include FormtasticBootstrap::Inputs::Base::Hints
  
  
  def generic_input_wrapping_without_label(&block)
    clearfix_div_wrapping do
      input_div_wrapping do
        if options[:prepend]
          prepended_input_wrapping do
            [template.content_tag(:span, options[:prepend], :class => 'add-on'), yield].join("\n").html_safe
          end
        else
          yield
        end
      end
    end    
  end

  def wrapper_html_options
    super.merge(:class => [super[:class], "mb1"].join(" "))
  end
      
  def to_html
    generic_input_wrapping_without_label do  
       hidden_field_html << check_box_html << label_html
    end
  end

  def hidden_field_html
    template.hidden_field_tag(input_html_options[:name], unchecked_value, :id => nil, :disabled => input_html_options[:disabled] )
  end

  def check_box_html
    template.check_box_tag("#{object_name}[#{method}]", checked_value, checked?, input_html_options)
  end

  def unchecked_value
    options[:unchecked_value] || '0'
  end

  def checked_value
    options[:checked_value] || '1'
  end

  def checked?
    if defined? ActionView::Helpers::InstanceTag
      object && ActionView::Helpers::InstanceTag.check_box_checked?(object.send(method), checked_value)
    else
      object && boolean_checked?(object.send(method), checked_value) 
    end
  end
      
  private 

  def boolean_checked?(value, checked_value)
    case value
    when TrueClass, FalseClass
      value
    when NilClass
      false
    when Integer
      value != 0
    when String
      value == checked_value
    when Array
      value.include?(checked_value)
    else
      value.to_i != 0
    end
  end
  
  
end