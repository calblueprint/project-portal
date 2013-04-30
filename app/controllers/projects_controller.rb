class ProjectsController < ApplicationController
  respond_to :html, :json
  
  def show
    @project = Project.find(params[:id])
    @can_edit = user_signed_in?
    @openIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ? AND project_id = ?", 0, @project.slug], :order => "created_at")
    @pendingIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ? AND project_id = ?", 1, @project.slug], :order => "created_at")
    @resolvedIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ? AND project_id = ?", 2, @project.slug], :order => "created_at")
    @comments = @project.root_comments
    @new_comment = Comment.build_from(@project, current_user.id, "") if user_signed_in?
  end

  def index 
    if is_admin
      @projects = Project.order("created_at DESC").paginate(:page => params[:page], :per_page => 15)
    else
      @projects = Project.where(:approved => true).order("created_at DESC").paginate(:page => params[:page], :per_page => 15)
    end
    @title = "All Projects"
  end

  def search
    @projects = Project.order("created_at DESC").search(params, current_user.admin?).paginate(:page => params[:page], :per_page => 15)
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
    unless user_signed_in? and (current_user.admin? or (@project.user_id and current_user.id == @project.user.id))
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
    @questions = Question.current_questions
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
    respond_to do |format|
      #HTML
      format.html do 
        if @project.update_attributes(params[:project])
          approve_deny_project(@project)
        else
          @questions = Question.where(:id => @project.questions.map { |q| Project.get_question_id(q)})
          @questions = Question.current_questions if @questions.blank?
          render action: "edit"
        end
      end
      #JSON
      format.json do
        @project.update_attributes(params[:project])
        respond_with_bip(@project) 
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
  end

  def favorite
    @project = Project.find(params[:id])
    current_user.favorites.create :project => @project
    redirect_to project_path(@project)
  end

  def unfavorite
    @project = Project.find(params[:id])
    @favoritedproject = Favorite.where("project_id = ? AND user_id = ?", @project.id, current_user).limit(1)
    current_user.favorites.delete(@favoritedproject)
    redirect_to project_path(@project)
  end

  #to control comments
  def comment
    @project = Project.find(params[:id])
    @comment = Comment.build_from(@project, current_user.id, params[:comment][:body])
    if @comment.save
      render :partial => 'shared/project_comments', :locals => {:comment => @comment}, :layout => false, :status => :created
    else
      redirect_to @project, notice: 'Comment failed.' 
    end
  end

  def delete_comment
    @comment = Comment.find(params[:id])
    if @comment.destroy
      render :json => @comment, :status => :ok
    else
      redirect_to @project, notice: 'Deletion of Comment Failed.' 
    end
  end

  private
  def approve_deny_project(project)
    if params[:project][:approved].nil?
      # check if resubmitting a denied project
      if project.approved == false
        project.approved = nil 
        project.save
      end
      return redirect_to(@project, :notice => "Project was successfully updated.") 
    end
    comment = params[:project][:comment]
    if params[:project][:approved] == "true"
      flash[:notice] = "Project: '#{@project.title}' was successfully approved."
      UserMailer.project_approved(project, comment).deliver
    else
      UserMailer.project_denied(project, comment).deliver
      flash[:notice] = "Project: '#{@project.title}' was successfully denied."
    end
    redirect_to session[:return_to]
  end
  
  def user_can_update(project)
    user_signed_in? and (current_user.admin? or (project.user_id and current_user.id == project.user.id))
  end

end
