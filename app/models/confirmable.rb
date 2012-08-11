module Confirmable
  extend ActiveSupport::Concern
    
  included do
    ## Confirmable
    field :confirmation_token, :index => { :unique => true }
    field :confirmed_at, :as => :datetime
    field :confirmation_sent_at, :as => :datetime
    field :unconfirmed_email
      
    devise :confirmable
  end
    
end
