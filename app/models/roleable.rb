module Roleable
  extend ActiveSupport::Concern
  
  included do
    attr_protected :roles
    field          :roles, :as => :text
    serialize      :roles, Array
  end

  def role?(role)
    if self.roles
      self.roles.include? role.to_s
    else
      false
    end
  end
  alias :has_role? :role?
  alias :is? :role?

  def role!(role)
    self.send(:"roles=", []) if !self.roles

    if !self.has_role? role
      self.roles << role.to_s
      self.update_attribute(:roles, self.roles)
    end
  end
  alias :has_role! :role!
  alias :add_role  :role!


  def hasnt_role!(role)

    self.send(:"roles=", []) if !self.roles

    if self.has_role? role.to_s
      self.roles.delete(role)
      self.update_attribute(:roles, self.roles)
    end
  end
  alias :remove_role :hasnt_role!
  alias :delete_role :hasnt_role!
  alias :destroy_role :hasnt_role!
  


end






