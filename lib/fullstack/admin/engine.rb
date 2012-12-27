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
          Ckeditor::ApplicationController.class_eval do
            before_filter :authenticate_administrator!
          end
        end
                
    end
  end
end


