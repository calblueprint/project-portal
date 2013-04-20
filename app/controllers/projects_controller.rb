class ProjectsController < ApplicationController
  
  def show
    @project = Project.find(params[:id])

    @openIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ? AND project_id = ?", 0, @project.slug], :order => "created_at")
    @pendingIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ? AND project_id = ?", 1, @project.slug], :order => "created_at")
    @resolvedIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ? AND project_id = ?", 2, @project.slug], :order => "created_at")

    @favorite = @project.users.find(current_user) # FIXME
    @idkwtfbbq = ProjectsUsers.find(:all)

  end

  def index 
    if current_user and current_user.admin?
      @all_projects = Project.find(:all)
    else
      @all_projects = Project.where(:approved => true)
    end
    @title = "All Projects"
  end

  def search
    @all_projects = Project.search(params, current_user.admin?)
    @title = "Search Results"
    @prev_search = params
    p @prev_search
    render :index
  end

  def new
    @project = Project.new
    @questions = Question.current_questions
  end

  def edit
    @project = Project.find(params[:id])
    if not (current_user.admin? or (@project.user_id and current_user.id == @project.user.id))
      redirect_to @project, notice: 'You do not have permission to edit this project.' 
    end
    @questions = Question.where(:id => @project.questions.map { |q| Project.get_question_id(q)})
  end
  
  def user_edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(params[:project])
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
    if user_signed_in? and (current_user.admin? or (@project.user_id and current_user.id == @project.user.id))
      if @project.update_attributes(params[:project])
        if not params[:project][:approved].nil?
          if params[:project][:approved] == "true"
            UserMailer.project_approved(@project).deliver
          else
            UserMailer.project_denied(@project).deliver
          end
        else
          flash[:notice] = "Project was successfully updated."
        end
        redirect_to @project 
      else
        render action: "edit" 
      end
    else
        redirect_to @project, notice: 'You do not have permission to edit this project.'
    end 
  end

  def favorite
    @project = Project.find(params[:id])
    @project.users << current_user
    redirect_to project_path(@project)
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
  end

end
