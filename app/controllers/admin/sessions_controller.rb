class Admin::SessionsController < ApplicationController
  layout 'login'
  
  def new
    @user = Superuser.new
  end
  
  def create
    respond_to do |format|
      if @user = login(params[:username],params[:password])
        format.html { redirect_back_or_to("/", :notice => I18n.t("signed_in", :scope => "fullstack.admin", :default  => 'Signed in successfully.')) }
        format.xml { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { flash.now[:alert] = I18n.t("login_failed", :scope => "fullstack.admin", :default  => 'Login failed.'); render :action => "new" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
    
  def destroy
    logout
    redirect_to("/", :notice => I18n.t("signed_out", :scope => "fullstack.admin", :default  => 'Signed out successfully.'))
  end

end


