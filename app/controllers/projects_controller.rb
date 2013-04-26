class ProjectsController < ApplicationController
  respond_to :html, :json
  
  def show
    @project = Project.find(params[:id])
    @can_edit = user_signed_in?
    @openIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ? AND project_id = ?", 0, @project.slug], :order => "created_at")
    @pendingIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ? AND project_id = ?", 1, @project.slug], :order => "created_at")
    @resolvedIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ? AND project_id = ?", 2, @project.slug], :order => "created_at")
  end

  def index 
    if is_admin
      @projects = Project.paginate(:page => params[:page], :per_page => 15)
    else
      @projects = Project.where(:approved => true).paginate(:page => params[:page], :per_page => 15)
    end
    @title = "All Projects"
    render :nothing => true if @projects.blank? and params[:page].to_i > 1 
  end

  def search
    @projects = Project.search(params, current_user.admin?)
    @projects = @projects.paginate(:page => params[:page], :per_page => 15)
    @title = "Search Results"
    @prev_search = params
    if @projects.blank? and params[:page].to_i > 1
      render :nothing => true
    else
      render :index
    end
  end

  def new
    @project = Project.new
    @questions = Question.current_questions
  end

  def edit
    @project = Project.find(params[:id])
    unless user_signed_in? and (current_user.admin? or (@project.user_id and current_user.id == @project.user.id))
      redirect_to @project, notice: 'You do not have permission to edit this project.' 
    end
    @questions = Question.where(:id => @project.questions.map { |q| Project.get_question_id(q)})
    @questions = Question.current_questions if @questions.blank?
  end
  
  def user_edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(params[:project])
    @project["user_id"] = current_user.id
    if @project.save
      redirect_to @project, notice: 'Project was successfully created.' 
    else
      render action: "new" 
    end
  end

  def update
    @project = Project.find(params[:id])
    unless user_can_update(@project)
      return redirect_to @project, notice: 'You do not have permission to edit this project.'
    end
    if @project.update_attributes(params[:project])
      approve_deny_project(@project)
    end
    respond_to do |format|
      format.html { redirect_to(@project, :notice => 'User was successfully updated.') }
      format.json { respond_with_bip(@project) }
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
  end
  
  
  private
  def approve_deny_project(project)
    if params[:project][:approved].nil?
      return flash[:notice] = "Project was successfully updated."
    end
    comment = params[:project][:comment]
    if params[:project][:approved] == "true"
      UserMailer.project_approved(project, comment).deliver
    else
      UserMailer.project_denied(project, comment).deliver
    end
  end
  
  def user_can_update(project)
    user_signed_in? and (current_user.admin? or (project.user_id and current_user.id == project.user.id))
  end

end
