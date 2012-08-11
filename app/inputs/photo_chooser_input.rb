class PhotoChooserInput < FormtasticBootstrap::Inputs::HiddenInput

  def to_html
    template.after_current_form(:photo_chooser, :replace => true) << template.render(:partial => "support/photos/chooser")
    super << template.render(:partial => "support/photos/input")
  end
  
end