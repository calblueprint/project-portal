class ApplicationsController < ApplicationController
  respond_to :html, :json

  def index
    @project = Project.find(params[:project_id])
    @applications = @project.applications
    @other_orgs = Organization.not_applied(@project)
  end

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

  def create
    application = Application.create(:organization_id => params[:organization_id], :project_id => params[:project_id])
    redirect_to edit_project_application_path(params[:project_id], application)
  end

  def destroy
    project = Project.find(params[:project_id])
    application = Application.find(params[:id])
    application.destroy

    redirect_to project_applications_path(project)
  end

end
