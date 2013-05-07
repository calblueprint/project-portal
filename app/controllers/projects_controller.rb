class ProjectsController < ApplicationController
  respond_to :html, :json
  
  def show
    @project = Project.find(params[:id])
    @can_edit = user_signed_in?
    @openIssues = Issue.find(:all, :limit => 5, :conditions => ["resolved = ? AND project_id = ?", 0, @project.id], :order => "created_at")
    @pendingIssues = Issue.find(:all, :limit => 3, :conditions => ["resolved = ? AND project_id = ?", 1, @project.id], :order => "created_at")
    @resolvedIssues = Issue.find(:all, :limit => 3, :conditions => ["resolved = ? AND project_id = ?", 2, @project.id], :order => "created_at")
    @comments = @project.root_comments
    @new_comment = Comment.build_from(@project, current_user.id, "") if user_signed_in?
  end

  def index 
    if is_admin
      @projects = Project.order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    else
      @projects = Project.where(:approved => true).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    end
    @title = "All Projects"
  end

  def search
    @projects = Project.order("created_at DESC").search(params, (user_signed_in? and current_user.admin?)).paginate(:page => params[:page], :per_page => 10)
    @title = "Search Results"
    @prev_search = params
    render :index
  end

  def new
    @project = Project.new
    @questions = Question.current_questions
  end

  def edit
    @project = Project.find(params[:id])
    permission_to_update(@project)
    @questions = @project.project_questions
    @emails = []
    users = User.connection.select_all("SELECT email,fname,lname FROM users")
    users.each do |u|
      @emails.append("#{u['fname']} #{u['lname']} (#{u['email']})")
    end
    unless user_signed_in? and (current_user.admin? or (@project.user_id and current_user.id == @project.user.id))
      redirect_to @project, notice: 'You do not have permission to edit this project.' 
    end
    @user = @project.user
  end

  def create
    @questions = Question.current_questions
    @project = Project.new(params[:project], :as => :owner)
    @project["user_id"] = current_user.id
    @questions = Question.current_questions
    if @project.save
      redirect_to @project, notice: 'Project was successfully created.' 
    else
      render action: "new" 
    end
  end

  def update
    @project = Project.find(params[:id])
    permission_to_update(@project)
    if params[:project][:project_owner]
      params[:project][:user_id] = get_user_id_from_email(params[:project][:project_owner])
    end
    params[:project].delete(:project_owner)
    if @project.approved == false
      params[:project][:approved] = nil
    end
    if current_user.admin? and @project.update_attributes(params[:project], :as => :admin) or @project.update_attributes(params[:project], :as => :owner)
      redirect_to(@project, :notice => "Project was successfully updated.") 
    else
      @questions = @project.project_questions
      render action: "edit"
    end
  end
  
  def approval
    @project = Project.find(params[:id])
    permission_to_update(@project)
    if current_user.admin? and @project.update_attributes(params[:project], :as => :admin)
      approve_deny_project(@project)
    end
    redirect_to session[:return_to]
  end

  def public_edit
    @project = Project.find(params[:id])
    @project.update_attributes(params[:project])
    respond_with_bip(@project)
  end
  
  def destroy
    @project = Project.find(params[:id])
    @project.destroy
  end

  def favorite
    @project = Project.find(params[:id])
    current_user.favorites.create :project => @project
    if current_user.email_notification.fav_projects and current_user != @project.user
      UserMailer.favorited_project(@project, current_user).deliver
    end
    redirect_to session[:return_to]
  end

  def unfavorite
    @project = Project.find(params[:id])
    @favoritedproject = Favorite.where("project_id = ? AND user_id = ?", @project.id, current_user).limit(1)
    current_user.favorites.delete(@favoritedproject)
    redirect_to session[:return_to]
  end

  #to control comments
  def comment
    @project = Project.find(params[:id])
    @comment = Comment.build_from(@project, current_user.id, params[:comment][:body])
    if @comment.save
      render :partial => 'shared/project_comments', :locals => {:comment => @comment}, :layout => false, :status => :created
    else
      flash[:error] = 'Comment failed.' 
      redirect_to @project
    end
  end

  def delete_comment
    @comment = Comment.find(params[:id])
    if @comment.destroy
      render :json => @comment, :status => :ok
    else
      flash[:error] = 'Deletion of Comment Failed.' 
      redirect_to @project
    end
  end

  private
  def approve_deny_project(project)
    comment = params[:project][:comment]
    enotifer_on = current_user.email_notification.proj_approval 
    if params[:project][:approved] == "true"
      flash[:notice] = "Project: '#{project.title}' was successfully approved."
      UserMailer.project_approved(project, comment).deliver unless not enotifer_on 
    else
      UserMailer.project_denied(project, comment).deliver unless not enotifer_on
      flash[:notice] = "Project: '#{project.title}' was successfully denied."
    end
  end
  
  private
  
  def user_can_update(project)
    user_signed_in? and (current_user.admin? or (project.user_id and current_user.id == project.user.id))
  end
  
  def permission_to_update(project)
    unless user_can_update(project)
      flash[:error] = 'Youd do not have permission to edit this project.'
      return redirect_to project
    end
  end
  
  def get_user_id_from_email(email_string)
    email = /[a-zA-Z\d-_!#\$%&'*+-\/=?^_`{.|}~]+[@]{1}+[a-zA-Z\d-]+[.]{1}[a-zA-Z]+/.match(email_string).to_s
    user = User.find_by_email(email)
    user.id
  end

end
