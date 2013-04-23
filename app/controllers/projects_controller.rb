class ProjectsController < ApplicationController

  def show
    @project = Project.find(params[:id])

    @openIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ? AND project_id = ?", 0, @project.slug], :order => "created_at")
    @pendingIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ? AND project_id = ?", 1, @project.slug], :order => "created_at")
    @resolvedIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ? AND project_id = ?", 2, @project.slug], :order => "created_at")

  end

  def index 
    if current_user and current_user.admin?
      @projects = Project.paginate(:page => params[:page], :per_page => 15)
    else
      @projects = Project.where(:approved => true).paginate(:page => params[:page], :per_page => 15)
    end
    @title = "All Projects"
  end

  def search
    @projects = Project.search(params, current_user.admin?).paginate(:page => params[:page], :per_page => 15)
    @title = "Search Results"
    @prev_search = params
    render :index
  end

  def new
    @project = Project.new
    #@questions = Question.where(:id => @project.questions.map { |q| Project.get_question_id(q)})
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
    @questions = Question.current_questions
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
    if user_signed_in? and (current_user.admin? or (@project.user_id and current_user.id == @project.user.id))
      if @project.update_attributes(params[:project])
        if not params[:project][:approved].nil?
          comment = params[:project][:comment]
          if params[:project][:approved] == "true"
            UserMailer.project_approved(@project, comment).deliver
          else
            UserMailer.project_denied(@project, comment).deliver
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

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
  end

end
