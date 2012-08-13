require 'rails'
require "ckeditor"
require 'fullstack'

module Fullstack
  module Admin
    class Engine < ::Rails::Engine

        initializer "fullstack-admin precompile" do |app|
          app.config.assets.precompile += Ckeditor.assets
        end
        
        initializer 'fullstack.autoload', :after => :set_autoload_paths do |app|
          Ckeditor.setup do |config|
            require "ckeditor/orm/active_record"
          end

          if Object.const_defined?("UserSubject")

            Ckeditor::ApplicationController.class_eval do
              authorize(:scope => :admin)
            end

          end
        end
                
    end
  end
end


