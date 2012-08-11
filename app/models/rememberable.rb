module Rememberable
  extend ActiveSupport::Concern
    
  included do
    ## Rememberable
    field :remember_created_at, :as => :datetime
    devise :rememberable
    attr_accessible :remember_me  
  end
    
end
