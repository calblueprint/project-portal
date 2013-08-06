class UserRegistrationsController < Devise::RegistrationsController
  
  def new
    # params[:user][:user_type] ||= session[:user_type]
    @user_type = params[:user][:user_type]
    if @user_type != nil
      session[:user_type] = @user_type
      puts 'assigned' + @user_type + 'in session'
    else
      @user_type = session[:user_type]
      puts 'getting' + @user_type + 'from session'
    end
    super
  end

  def create
    # customized code begin
    # Getting the user type that is send through a hidden field in the registration form.
    
    if @user_type == nil
      @user_type = session[:user_type]
      puts 'getting' + @user_type + 'from session'
    end

    user_type = params[:user][:user_type]
    user_type_params = params[:user][user_type]

    # Deleting the user_type from the params hash, won't work without this.
    params[:user].delete(:user_type)
    params[:user].delete(user_type)

    # Building the user, I assume.
    build_resource(sign_up_params)

    # create a new child instance depending on the given user type
    #hild_class = params[:user][:user_type].camelize.constantize
    child_class = user_type.camelize.constantize
    #resource.rolable = child_class.new(params[child_class.to_s.underscore.to_sym])
    resource.rolable = child_class.new(user_type_params)

    # first check if child instance is valid
    # cause if so and the parent instance is valid as well
    # it's all being saved at once
    valid = resource.valid?
    valid = resource.rolable.valid? && valid
    # customized code end

    if valid && resource.save    # customized code
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => redirect_location(resource_name, resource)
      else
        set_flash_message :notice, :inactive_signed_up, :reason => resource.inactive_message if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      resource[:user_type] = user_type
      clean_up_passwords(resource)
      session[:user_type] = user_type
      respond_with_navigational(resource)
    end
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    # customized code begin
    if @user_type == nil
      @user_type = resource.rolable_type.downcase
      puts 'getting ' + @user_type + ' from session'
    end

    user_type_params = params[:user][@user_type]
    child_class = @user_type.camelize.constantize

    puts "DOPE"
    puts user_type_params

    resource.rolable.update_attributes(user_type_params)

    # Deleting the user_type from the params hash, won't work without this.
    params[:user].delete(@user_type)
    # customized code end

    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if resource.update_with_password(account_update_params)
      if is_navigational_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  private

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
    user.email != params[:user][:email] ||
      !params[:user][:password].blank?
  end

  protected
end