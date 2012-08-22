class SimpleMarkupInput < FormtasticBootstrap::Inputs::TextInput

  def input_html_options
    super.merge(:class => "markup")
  end

  def wrapper_html_options
    super.merge(:class => "mb1")
  end
    

end
