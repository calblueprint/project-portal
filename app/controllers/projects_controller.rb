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
    @questions = Question.current_questions
  end

  def edit
    @project = Project.find(params[:id])
    permission_to_update(@project)
    @questions = @project.project_questions
  end
  
  def user_edit
    @project = Project.find(params[:id])
  end #TODO remove this crap

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
    permission_to_update(@project)
    if @project.update_attributes(params[:project])
      if @project.approved == false # check if resubmitting a denied project
        @project.approved = nil 
        @project.save
      end
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
    if params[:project][:approved] == "true"
      flash[:notice] = "Project: '#{project.title}' was successfully approved."
      UserMailer.project_approved(project, comment).deliver
    else
      UserMailer.project_denied(project, comment).deliver
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

end
