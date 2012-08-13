require 'rails'
require "ckeditor"

module Fullstack
  module Admin
    class Engine < ::Rails::Engine
        initializer "fullstack-admin precompile" do |app|
          app.config.assets.precompile += Ckeditor.assets
        end
    end
  end
end