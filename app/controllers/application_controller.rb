class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :prev_path
  
  def prev_path
    session[:return_to] = request.referer
  end
  
  protected
  def authorize_user
    unless current_user.admin?
      flash[:error] = "You do not have permissions to perform that action"
      redirect_to "/dashboard"
    end
  end
end
