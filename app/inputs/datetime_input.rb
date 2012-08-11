class DatetimeInput
  include Formtastic::Inputs::Base
  include FormtasticBootstrap::Inputs::Base::Labelling
  include FormtasticBootstrap::Inputs::Base::Wrapping
  include FormtasticBootstrap::Inputs::Base::Errors
  include FormtasticBootstrap::Inputs::Base::Hints
  
#   def wrapper_html_options
# #    super.merge(:class => "mb1")
#   end
    
  def to_html
    generic_input_wrapping do
       builder.datetime_select(method)
    end
  end
  
end