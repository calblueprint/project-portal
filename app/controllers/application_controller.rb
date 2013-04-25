class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  before_filter :prev_path
  
  def prev_path
    session[:return_to] = request.referer
  end
  
  def is_admin
    user_signed_in? and current_user.admin?
  end

  protected
  def authorize_user
    unless is_admin
      flash[:error] = "You do not have permissions to perform that action"
      redirect_to "/dashboard"
    end
  end
end
