class ProjectsController < ApplicationController
  
  def show
    @project = Project.find(params[:id])

    @openIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ? AND project_id = ?", 0, @project.slug], :order => "created_at")
    @pendingIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ? AND project_id = ?", 1, @project.slug], :order => "created_at")
    @resolvedIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ? AND project_id = ?", 2, @project.slug], :order => "created_at")
  end

  def index 
    @all_projects = Project.where(:approved => true)
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
    if not (current_user.admin? or (@project.user_id and current_user.id == @project.user.id))
      redirect_to @project, notice: 'You do not have permission to edit this project.' 
    end
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
    if user_signed_in? and (current_user.admin? or (@project.user_id and current_user.id == @project.user.id))
      if @project.update_attributes(params[:project])
        redirect_to @project, notice: 'Project was successfully updated.' 
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
