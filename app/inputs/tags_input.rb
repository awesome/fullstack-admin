class TagsInput < FormtasticBootstrap::Inputs::StringInput
    def input_html_options
      super.merge(:class => "taglist", :data => {:autocomplete => @options[:autocomplete], :text => @options[:text]})
    end
    
    def wrapper_html_options
      super.merge(:class => "mb1")
    end
    
end
