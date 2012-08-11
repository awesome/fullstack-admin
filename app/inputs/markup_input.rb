class MarkupInput < FormtasticBootstrap::Inputs::TextInput

  def input_html_options
    super.merge(:class => "markup-ckeditor")
  end

  def wrapper_html_options
    super.merge(:class => "mb1")
  end
    

end
