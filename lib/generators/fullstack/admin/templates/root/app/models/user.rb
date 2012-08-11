class User < ActiveRecord::Base
  include Authenticatable
  include Confirmable
  include Registerable
  include Rememberable
  include Trackable    
  include Recoverable
  include Roleable

#  include Suspendable
end
