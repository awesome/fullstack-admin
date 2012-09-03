module Positionable
  extend ActiveSupport::Concern
  
  MAX_POS = 32768 # maximum 2 bytes integer
  
  included do
    field :position, :integer, :default => MAX_POS
  end

  module ClassMethods
    def update_positions(id_pos_pairs)
      self.transaction do
        id_pos_pairs.each do |pair|
          self.find(pair[:id]).update_attributes!(:position => pair[:position])
        end
      end
    end
  end


  class << self
    
    def get(class_name)
      @_positionable_flyweight ||= {}
      underscored_name = class_name.is_a?(Class) ? class_name.name.underscore : class_name.to_s.underscore.singularize
      @_positionable_flyweight[underscored_name] || (@_positionable_flyweight[underscored_name] = class_name.is_a?(Class) ? class_name : "#{underscored_name}".camelize.constantize)
    end
        
  end

end