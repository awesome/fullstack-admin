module Fullstack
  module Admin
    class LocaleGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../../../../../locales', __FILE__)
    
      def install
        create_file Rails.root.join("config", "locales", "fullstack.admin.#{name}.yml")
      end
    
    end
  end
end