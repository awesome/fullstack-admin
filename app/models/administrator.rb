class Administrator < ActiveRecord::Base

  ## Database authenticatable
  field :username, :null => false, :default => "", :index => { :unique => true }
  field :email
  field :encrypted_password, :null => false, :default => ""
  timestamps

  ## Trackable
  field :sign_in_count, :as => :integer, :default => 0
  field :current_sign_in_at, :as => :datetime
  field :last_sign_in_at, :as => :datetime
  field :current_sign_in_ip
  field :last_sign_in_ip
    
  ## Lockable
  field :failed_attempts, :integer, :default => 0
  field :unlock_token
  field :locked_at, :datetime
      
  devise :database_authenticatable, :validatable, :lockable, :trackable, :authentication_keys => [:username] 
  attr_accessible :username, :email, :password, :password_confirmation
  
  def has_role?(role)
    %w(administrator logged_in).include?( role.try(:to_s) ) ? true : false
  end

end
