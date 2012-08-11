module Trackable
  extend ActiveSupport::Concern
    
  included do
    ## Trackable
    field :sign_in_count, :as => :integer, :default => 0
    field :current_sign_in_at, :as => :datetime
    field :last_sign_in_at, :as => :datetime
    field :current_sign_in_ip
    field :last_sign_in_ip
      
    devise :trackable      
  end
    
end

