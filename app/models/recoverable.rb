module Recoverable
  extend ActiveSupport::Concern
    
  included do
    ## Recoverable
    field :reset_password_token, :index => { :unique => true }
    field :reset_password_sent_at, :as => :datetime

    devise :recoverable
      
  end
    
end
