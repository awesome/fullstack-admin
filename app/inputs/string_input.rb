class StringInput < FormtasticBootstrap::Inputs::StringInput
    def input_html_options
      super.merge(:"data-limit" => @options[:limit])
    end
end
