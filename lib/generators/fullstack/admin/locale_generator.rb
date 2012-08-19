module Fullstack
  module Admin
    class LocaleGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../../../../../locales', __FILE__)
    
      def install
        generate "fullstack:locale #{name}"   
      end
    
    end
  end
end