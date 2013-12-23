class ApplicationsController < ApplicationController
  respond_to :html, :json

  def edit
    @application = Application.find_by_id(params[:id])
    @project = Project.find(params[:project_id])
    @organization = @application.organization
  end


  def update
    @application = Application.find_by_id(params[:id])
    @project = Project.find(params[:project_id])
    if @application.update_attributes(params[:application])
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      flash[:warning] = "Application was unsuccessful."
      redirect :back
    end

  end

end
