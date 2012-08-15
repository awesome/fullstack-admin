module Fullstack
  module Admin
    class ScaffoldGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates/scaffold', __FILE__)

      argument :name, :required => true
      class_option :views, :type => :boolean, :default => true
        
      

      def create_controller_files
        template 'controller.rb', File.join("app/controllers/", scope, "#{file_name.pluralize}_controller.rb")
      end
      
      def add_routes
        routes_rb = Rails.root.join('config', 'routes.rb') 
        
        altered_lines = []
        File.open(routes_rb) do |file|
          lines = file.read.split("\n")
          lines.each do |line|
            if line =~ /^ \s* namespace \s+ :#{scope} \s+ do /x
              leading_space = line.match(/^(\s*)/)[1] + "  "
              line = [line,  "#{leading_space}resources :#{plural_name}, :except => [:show]"].join("\n")
            end
            altered_lines << line
          end
        end
        
        File.open(routes_rb, 'w') do |file|
         file.write(altered_lines.join("\n"))
        end
        
        say("addedd 'resources :#{plural_name}, :except => [:show]' to namespace ':#{scope}' in routes.rb")
      end
      
      def create_views
        if options[:views]
          directory('views', Rails.root.join('app', 'views', scope, plural_name))
          if has_timestamps? || title_column
            template "_filter.html.erb", Rails.root.join('app', 'views', scope, plural_name, "_filter.html.erb")
          end
        end
      end
      
      def append_to_menu
        placeholder_text = "FULLSTACK_PLACEHOLDER"
        gsub_file(Rails.root.join('app', 'views', scope, "shared", "_nav.html.erb"), /\<\!-- #{placeholder_text} --\>\n/) do
<<-str
      <%= nav_item t('active_record.models.#{plural_name}', :default => "#{controller_class_name}"), #{scope}_#{plural_name}_path %>
      <!-- #{placeholder_text} -->
          
str
        end
      end
      
      protected
      
      def class_name
        name.singularize.camelize
      end
      
      def scope
        @scope ||= "admin"
      end
      
      def plural_name
        name.pluralize
      end
      
      def singular_name
        name.singularize
      end
      
      def scope_class
        scope.camelize
      end
      
      # def inputs
      #     exclude_attributes = model.protected_attributes.to_a + %W(created_at updated_at slug)    
      #     columns = model.columns_hash.map {|k, v| [k, v.type]}.delete_if {|k, t| exclude_attributes.include?(k)}
      # end

      def has_timestamps?
        model.columns_hash["created_at"]
      end
      
      def title_column
        ( model.column_names & %W(title name label browser_title seo_title seo_name key claim email) ).first
      end
      
      def controller_class_name
        class_name.pluralize
      end
      
      def resource_class_name
        class_name.singularize
      end
      
      def resource_name
        file_name.singularize
      end
      
      def collection_name
        file_name.pluralize
      end
      
      def file_name
        name
      end
      
      def model
        class_name.constantize
      end

      def content?
        options[:content]
      end

    end
  end
end
