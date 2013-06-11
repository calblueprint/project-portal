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

# Overriding the Devise current_user method
  alias_method :devise_current_user, :current_user
  def current_user
    super
  end
  def current_rolable
    current_user.rolable
  end
  def current_rolable_type
    current_user.rolable_type
  end

  def is_developer?
    current_user.rolable.class.name == 'Developer'
  end
  def is_client?
    current_user.rolable.class.name== 'Client'
  end
  def is_organization?
    current_user.rolable.class.name == 'Organization'
  end

  protected
  def authorize_user
    unless is_admin
      flash[:error] = "You do not have permissions to perform that action"
      redirect_to "/dashboard"
    end
  end

  #   # Overriding the Devise current_user method
  # alias_method :devise_current_user, :current_user
  # def current_user
  #   # It will now return either a Company or a Customer, instead of the plain User.
  #   super.rolable
  # end
end
