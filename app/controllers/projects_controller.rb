class ProjectsController < ApplicationController
  respond_to :html, :json

  def new
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
    unless user_can_update?(@project)
      redirect_to @project, notice: 'You do not have permission to edit this project.'
    end
    @user = @project.client
  end

  def org_questions
    @project = Project.new

    if params[:project].nil?
      org_params = session[:org]
      proj_params = session[:proj]
    else
      org_params = params[:project][:organizations]
      params[:project].delete(:organizations)
      proj_params = params[:project]
    end

    session[:org] = org_params
    session[:proj] = proj_params

    puts 'org params'
    puts org_params

    @organizations = []
    Organization.all.each do |org|
      if org_params[org.sname] == "1"
        @organizations << org
      end
    end
  end

  def create

    org_params = session[:org]
    proj_params = session[:proj]

    @project = Project.new(proj_params)
    # @project = Project.new(proj_params, :as => :owner)
    @project.client = current_rolable

    @project.questions = params[:project][:questions]
    @project.problem = params[:project][:problem]
    @project.short_description = params[:project][:short_description]
    @project.long_description = params[:project][:long_description]

    Organization.all.each do |org|
      if org_params[org.sname] == "1"
        puts org.name
        @project.organizations << org
      end
    end

    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render action: "new"
    end
  end

  def show
    @project = Project.find(params[:id])
    @openIssues = Issue.find(:all, :limit => 5, :conditions => ["resolved = ? AND project_id = ?", 0, @project.id], :order => "created_at")
    @pendingIssues = Issue.find(:all, :limit => 3, :conditions => ["resolved = ? AND project_id = ?", 1, @project.id], :order => "created_at")
    @resolvedIssues = Issue.find(:all, :limit => 3, :conditions => ["resolved = ? AND project_id = ?", 2, @project.id], :order => "created_at")
    @comments = @project.root_comments
    @new_comment = Comment.build_from(@project, current_user.id, "") if user_signed_in?
  end

  def index
    # if is_admin
    #   @projects = Project.order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    # else
    @projects = Project.order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    #end
    @title = "All Projects"
  end

  def search
    @projects = Project.order("created_at DESC").search(params, (user_signed_in? and current_user.admin?)).paginate(:page => params[:page], :per_page => 10)
    @title = "Search Results"
    @prev_search = params
    render :index
  end

  def update
    @project = Project.find(params[:id])
    permission_to_update(@project)
    # if params[:project][:project_owner]
    #   params[:project][:user_id] = get_user_id_from_email(params[:project][:project_owner])
    # end
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

  def permission_to_update(project)
    unless user_can_update?(project)
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
