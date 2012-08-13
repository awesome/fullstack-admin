if Object.const_defined?("Ckeditor")
  Ckeditor.setup do |config|
    require "ckeditor/orm/active_record"
  end

  Ckeditor::ApplicationController.class_eval do
    authorize(:scope => :admin)
  end
end
