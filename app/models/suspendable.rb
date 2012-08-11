module Suspendable
  extend ActiveSupport::Concern
  
  included do
    field :suspended_at, :as => :datetime
    scope :suspended, where("suspended_at IS NULL")
  end
  
  def active?
    super && !suspended? 
  end 

  def inactive_message 
    !suspended? ? super : :suspended 
  end 

  def suspend!
    update_attributes(:suspended_at => Time.now.utc) 
  end 

  def unsuspend! 
    update_attributes(:suspended_at => nil) 
  end 

  def suspended? 
    !suspended_at.nil? 
  end
  
end