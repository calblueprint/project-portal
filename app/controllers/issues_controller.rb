class IssuesController < ApplicationController
  respond_to :html, :json

    #displays a specfic issue 
  def show
    @issue = Issue.find(params[:id])
    #check if you can edit the issue
    @project = Project.find(@issue.project_id)
    @canEdit = isOwner(@project)
  end

  def new
    @title = "Create an Issue"
    @issue = Issue.new
    #@issue.resolved = false
  end

  #actually creates a new issue
  def create
    @issue = Issue.new(params[:id])
    @issue.project_id = params[:proj_id]
    @issue.resolved = 0
    @issue.title = params[:issue][:title]
    @issue.description = params[:issue][:description]

    if @issue.save
      flash[:notice] = "Your Issue was Added"
      redirect_to(:action => 'show', :id => @issue)
    else
      flash[:error] = "Error in Saving. Please retry."
      render action: "new"
    end
  end

  #saves the changes
  def update
    @issue = Issue.find(params[:id])
    respond_to do |format|
      if @issue.update_attributes(params[:issue])
        format.html { redirect_to(@issue, :notice => 'User was successfully updated.') }
        format.json { respond_with_bip(@issue) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@issue) }
      end
    end
  end

  #when someone submits a solution to a Issue
  def resolve
    @issue = Issue.find(params[:id])
    @issue.resolved = 1
    @issue.authors = params[:solution][:author]
    @issue.github = params[:solution][:github]

    #update latest repo for the project
    @project = Project.find(@issue.project_id)
    @project.github_site = params[:solution][:github]

    #TODO: @project.save and 
    #@project.update_attributes(params[:project])
    if @project.save && @issue.save 
      flash[:notice] = "Your Solution was Submitted"
      redirect_to(:action => 'show', :id => @issue)
    else
      flash[:error] = "Error in Saving. Please retry."
      redirect_to(:action => 'show', :id => @issue)
    end
  end

  #when the company accepts a solution to the issue
  def accept
    @issue = Issue.find(params[:id])
    @issue.resolved = 2
    if @issue.save
      flash[:notice] = "The Solution was Accepted"
      redirect_to(:action => 'show', :id => @issue)
    else
      flash[:error] = "Error in Saving. Please retry."
      redirect_to(:action => 'show', :id => @issue)
    end
  end

  #when the company denys a solution to the issue
  def deny
    @issue = Issue.find(params[:id])
    @issue.resolved = 0
    if @issue.save
      flash[:warning] = "The Solution was Rejected"
      redirect_to(:action => 'show', :id => @issue)
    else
      flash[:error] = "Error in Saving. Please retry."
      redirect_to(:action => 'show', :id => @issue)
    end
  end

  def isOwner(project)
    if not (current_user.admin? or (project.user_id and current_user.id == project.user.id))
      return false
    else
      return true
    end
  end

end










