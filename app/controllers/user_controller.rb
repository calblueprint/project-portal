class UserController < ApplicationController
  def show
    if user_signed_in?
      @projects = Project.order("created_at DESC").find_all_by_user_id(current_user.id)
      @favorites = current_user.favorite_projects
    else
      redirect_to new_user_session_path, notice: 'Please log in to view your dashboard.'
    end
  end
  
  def admin_dashboard
    @questions = Question.current_questions
    @unapproved_projects = Project.order("created_at DESC").unapproved_projects.paginate(:page => params[:page], :per_page => 5)
    @denied_projects = Project.order("created_at DESC").denied_projects.paginate(:page => params[:page], :per_page => 5)
    @emails = []
    users = User.connection.select_all("SELECT email,fname,lname FROM users")
    users.each do |u|
      @emails.append(u['fname'] + " " + u['lname'] + " " + "(" + u['email'] + ")")
    end
  end

  def add_admin
    if params[:commit] == "Add"
      email = /[a-zA-Z\d-_!#\$%&'*+-\/=?^_`{.|}~]+[@]{1}+[a-zA-Z\d-]+[.]{1}[a-zA-Z]+/.match(params[:user]).to_s
      create_admin(email)
    elsif params[:commit] == "View All"
      view_all_admins
    end
  end

  def create_admin(email)
    @email = email
    @user = User.find_by_email(@email)
    if @user and not @user.admin?
      @user.update_attributes(:admin=>true)
      redirect_to user_settings_path, notice: "#{@user.fname} #{@user.lname} is now an admin."      
    elsif @user and @user.admin?
      redirect_to user_settings_path, notice: "#{@user.fname} #{@user.lname} is already an admin."      
    else
      flash[:error] =  "#{@email} does not exist. Would you like to create a user?"
      redirect_to user_settings_path    
    end
  end

  def view_all_admins
    if user_signed_in? and current_user.admin?
      @all_admins = User.find_all_by_admin(true)
    elsif user_signed_in?
      flash[:error] = "You do not have the right permissions to view this page."
      redirect_to dashboard_path
    else
      flash[:error] = "Please log in."
      redirect_to new_user_session_path
    end
  end

  def remove_admin
    @user = User.find_by_id(params[:id])
    if @user and @user.admin?
      @user.update_attributes(:admin=>false)
      redirect_to user_settings_path, notice: "#{@user.fname} #{@user.lname} is no longer an admin."
    else
      flash[:error] = "Your action is invalid."
      redirect_to user_settings_path
    end
  end
end
