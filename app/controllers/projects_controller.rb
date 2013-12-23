class ProjectsController < ApplicationController
  respond_to :html, :json

  def new
    @project = Project.new
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

  #second step in new/edit project form
  # def org_questions
  #   @project = Project.new

  #   if params[:project].nil?
  #     org_ids = session[:org]
  #     proj_params = session[:proj]
  #   else
  #     org_ids = []
  #     params[:project][:organizations].each do |key, value|
  #       org_ids << key if value == "1"
  #     end
  #     params[:project].delete(:organizations)

  #     session[:org] = org_ids   #keeps org info on refresh
  #     session[:proj] = params[:project]
  #   end

  #   @organizations = org_ids.map { |id| Organization.find(id)}
  # end

  def create
    org_params = params[:project][:organizations]
    params[:project].delete(:organizations)

    @project = Project.new(params[:project])
    @project.client = current_rolable

    org_params.each do |id, val|
      @project.applications.build(:organization_id => id) if val == "1"
    end

    if @project.save
      @project.applications.to_a.each do |app|
        if app.questions.empty?
          redirect_to edit_project_application_path(@project, app) and return
        end
      end
      redirect_to @project, notice: 'Project was successfully created.'
    else
      flash[:warning] = "Project creation was unsuccessful."
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
    if org_id = params[:organization_id]
      org = Organization.find_by_id(org_id) || Organization.find_by_sname(org_id)
      @projects = org.projects
    else
      @projects = Project.is_public
    end

    @projects = @projects.order("created_at DESC").paginate(:page => params[:page], :per_page => 8)
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

  def edit_question
    @project = Project.find(params[:id])
    question = params[:question]
    answer = params["string"][:to_s]
    @project.questions[question] = answer
    if @project.save
      head :ok
    else
      flash[:error] = 'Editing questions failed.'
    end
  end

  def add_org
    project = Project.find(params[:id])
    org = Organization.find(params[:org_id])

    questions = {}
    org.questions.each do |q|
      questions[Project.question_key(q).to_s] = ""
    end
    project.questions = questions
    project.organizations << org
    if project.save
      redirect_to :back
    else
    end
  end

  def remove_orgs
    project = Project.find(params[:id])
    project.questions = nil
    project.organizations = []
    if project.save
      redirect_to :back
    else
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
