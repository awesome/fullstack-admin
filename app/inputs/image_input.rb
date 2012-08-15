class ImageInput < Formtastic::Inputs::FileInput
  

  def to_html
    raise "not implemented yet"
    # generic_input_wrapping do
    #   builder.file_field(method, input_html_options)
    # end
  end

end