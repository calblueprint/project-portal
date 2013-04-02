class ProjectsController < ApplicationController

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
    if not @project.user_id or current_user.id != @project.user.id
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
    if @project.user_id and current_user.id == @project.user.id
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
