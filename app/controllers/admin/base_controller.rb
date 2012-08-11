class Admin::BaseController < ApplicationController
  rescue_from Checkin::AccessDenied, :with => :rescue_access_denied

  layout 'admin'
  authorize(:scope => :admin)

  protected

  def rescue_access_denied
    if subject.guest?
      redirect_to new_user_session_path
    else
      render :text => "Not Authorized", :status => 403
    end
  end
  
  class << self
    def responder
    ::Admin::Responder
    end
  end
  
  
end