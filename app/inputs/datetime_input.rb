class DatetimeInput
  include Formtastic::Inputs::Base
  include FormtasticBootstrap::Inputs::Base::Labelling
  include FormtasticBootstrap::Inputs::Base::Wrapping
  include FormtasticBootstrap::Inputs::Base::Errors
  include FormtasticBootstrap::Inputs::Base::Hints
  
  def to_html
    bootstrap_wrapping do      
       builder.datetime_select(method, {}, {:class => "datetime-selector"})
    end
  end
  
end
