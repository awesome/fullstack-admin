#timeish.rb
module FormtasticBootstrap
  module Inputs
    module Base
      module Timeish

        def date_input_html
          current_value = @object.send(method)
          opts = input_html_options.merge({ :size => 24,
             :class => "datepicker",
             :max => 10,
             :readonly => 'readonly',
             :value => current_value.respond_to?(:strftime) ? current_value.strftime("%Y-%m-%d") : ""
             })
           builder.text_field(method, opts)
        end

        def time_input_html
           time_fragments.map do |fragment|
              fragment_input_html(fragment, "mini")
            end.join.html_safe
        end

        def fragment_input_html(fragment, klass)
          klass ||= ""
          klass += " datetime-selector"
          
          opts = input_options.merge(:prefix => fragment_prefix, :field_name => fragment_name(fragment), :default => value, :include_blank => include_blank?)
          template.send(:"select_#{fragment}", value, opts, input_html_options.merge(:id => fragment_id(fragment), :class => klass.strip))
        end

      end
    end
  end
end