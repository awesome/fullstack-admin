module Authenticatable
  extend ActiveSupport::Concern
  
included do
    
  ## Database authenticatable
  field :email, :null => false, :default => "", :index => { :unique => true }
  field :encrypted_password, :null => false, :default => ""
  timestamps
      
  devise :database_authenticatable, :validatable
         
  attr_accessible :email, :password, :password_confirmation

  end
end

