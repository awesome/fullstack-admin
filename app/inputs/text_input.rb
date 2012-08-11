class TextInput < FormtasticBootstrap::Inputs::TextInput
    def input_html_options
      super.merge(:"data-limit" => @options[:limit], :rows => (@options[:rows] || 5))
    end
end
