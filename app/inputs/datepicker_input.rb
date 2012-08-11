class DatepickerInput < FormtasticBootstrap::Inputs::StringInput
  def input_html_options
    options = super
    options[:class] = [options[:class], "datepicker"].compact.join(' ')
    options[:readonly] = 'readonly'
    options
  end
end

