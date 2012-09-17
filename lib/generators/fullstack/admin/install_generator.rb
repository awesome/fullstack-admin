module Fullstack
  module Admin
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
        
      class_option :fullstack, :type => :boolean, :default => true
    
      class_option :host, :default => "remotehost"
      class_option :user, :default => "ror"
      class_option :title, :default => "title"
      class_option :slogan, :default => "slogan"
    
      def install_fullstack
        if options[:fullstack]
          generate "fullstack:install  --host='#{host}' --user='#{user}'  --title='#{title}' --slogan='#{slogan}'"
        end
      end

      def copy_templates
        directory "root", Rails.root
      end
        
      def assets
        append_to_file "config/assets.yml" do
<<-eos

- admin/admin.css
- admin/admin.js          
eos
          
        end
      end
      

      def users
        generate "migration:from user"
        append_to_file "db/seeds.rb" do
<<-eos

if Rails.env.development?
  user = User.new( :email => "admin@example.com",
                    :password => "password" )
                  
  user.skip_confirmation! if user.respond_to?(:skip_confirmation!)             
  user.save!
  user.confirm! if user.respond_to?(:confirm)
  user.has_role!(:administrator) if user.respond_to?(:has_role!)
end
  
eos
          
        end
      
      end
      

      def append_routes
        src = <<-eos

  namespace :admin do
    root :to => "dashboard#show"
  end
  
eos
        route(src)
        
        route("\n  devise_for :users\n")
      end

      protected
      
      def migration_timestamp
        Time.now.strftime("%Y%m%d%H%M%S")
      end

      def host
        options[:host]
      end
    
      def user
         options[:user]
      end
    
      def app
        Rails.application.class.to_s.split("::").first.underscore      
      end
    
      def email
        "info@#{host}"
      end
    
      def title
        options[:title]      
      end
    
      def slogan
        options[:slogan]
      end
      
    end
  end
end
