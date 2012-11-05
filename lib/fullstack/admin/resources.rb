module Fullstack
  module Admin
    
    class Entity
      # leaf?
      # parent
      # children
      # entity_type
      
      def leaf?
        self.children.empty?
      end
      
      def traverse_top_down(&block)
        res = block.call(self)
        children.each do |c|
          c.traverse_top_down(&block)
        end
        res
      end
      alias :each :traverse_top_down
      
      def traverse_bottom_up(&block)
        children.each do |c|
          c.traverse_bottom_up(&block)
        end
        block.call(self)
      end
      alias :reverse_each :traverse_bottom_up
      
      
    end
  
    # =============
    # = Resources =
    # =============
    
    class Resources < Entity

      attr_accessor :children

      def initialize        
        @children = []
      end
      
      def group(name)
        g = Group.new(name)
        @children << g
        yield(g) 
      end
      
      def resource(name)
        @children << Resource.new(name)
      end
    
      def type
        :resources
      end
    
    end 
    
    # Group
    class Group < Entity      
      attr_accessor :children, :name, :icon
      
      def initialize(name)
        @name = "#{name}"
        @children = []
      end
      
      def resource(name)
        @children << Resource.new(name)
      end
      
      def type
        :group
      end
      
    end
    

    # Resource    
    class Resource < Entity

      attr_accessor :name
      
      def initialize(name)
        if name.is_a?(Class)
          name = name.name
        end
        @name = "#{name}"
      end
      
      def type
        :resource
      end
      
      def children
        @children ||= [].freeze
      end
      
    end

    # Fullstack::Admin.resources do |admin|
    #     
    #   admin.group :website do |g|
    #     g.resource :pages
    #     g.resource :menus
    #     g.resource :settings
    #   end
    # 
    #   admin.group :contents do |g|
    #     g.resource :posts        
    #   end
    #     
    #   admin.group :users do |g|
    #     g.resource :users
    #   end
    #     
    # end
    
    def resources
      @resources ||= Resources.new
      if block_given?
        yield(@resources)
      end
      @resources
    end
    
    module_function :resources
  
    def grouped_resources
      if !@resource_groups
        @resource_groups = {}
        current_group = nil
      
        resources.each do |rog|
          if rog.type == :group
            @resource_groups[rog] = []
            current_group = rog
          elsif current_group
            @resource_groups[current_group] << rog
          end
        end
      end
      @resource_groups
    end
    
    module_function :grouped_resources
  
  
  end
end

