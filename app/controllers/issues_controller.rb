class IssuesController < ApplicationController
  respond_to :html, :json


  def index
    #define the page to view
    if params[:pageNum] == nil or Integer(params[:pageNum]) < 2
      @page = 1 
    else
      @page = Integer(params[:pageNum])
    end

    if params[:search_string].nil?
      #retrieve issues that need to be displayed according to search params
      @openIssues = Issue.find(:all, :limit => 5,:offset => 5*(@page-1), :conditions => ["resolved = ?", 0], :order => "created_at")
      count = Issue.find(:all, :conditions => ["resolved = ?", 0]).size
    else
      @openIssues = Issue.search(params[:search_string]).find(:all, :limit => 5,:offset => 5*(@page-1), :conditions => ["resolved = ?", 0], :order => "created_at")
      count = Issue.find(:all, :conditions => ["resolved = ?", 0]).size
    end


    #set up range for pagination
    @start = @page - 2
    if @start < 1
      @start = 1
    end
    totalPages = (count / 5.0).ceil
    @end = @start + 5
    if @end > totalPages
      @end = totalPages+1
      while @end - @start != 5 and @start > 1
        @start = @start -1
      end
    end
  end

    #displays a specfic issue 
  def show
    @issue = Issue.find(params[:id])
    #check if you can edit the issue
    @project = Project.find(params[:project_id])
    @canEdit = isOwner(@project)
  end

  def new
    if not user_signed_in?
      redirect_to new_user_session_path, notice: "You must be logged in to create an issue."
    end
    @title = "Create an Issue"
    @issue = Issue.new
  end

  #actually creates a new issue
  def create
    @issue = Issue.new(params[:id])
    @issue.project_id = params[:project_id]
    @issue.resolved = 0
    @issue.title = params[:issue][:title]
    @issue.description = params[:issue][:description]

    if @issue.save
      flash[:notice] = "Your Issue was Added"
      redirect_to(:controller => "projects", :action => 'show', :id => @issue.project_id)
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
      redirect_to project_issue_path(@project.slug,@issue.id)
    else
      flash[:error] = "Error in Saving. Please retry."
      redirect_to project_issue_path(@project.slug,@issue.id)
    end
  end

  #when the company accepts a solution to the issue
  def accept
    @issue = Issue.find(params[:id])
    @issue.resolved = 2
    if @issue.save
      flash[:notice] = "The Solution was Accepted"
      redirect_to project_issue_path(@issue.project_id,@issue.id)
    else
      flash[:error] = "Error in Saving. Please retry."
      redirect_to project_issue_path(@issue.project_id,@issue.id)
    end
  end

  #when the company denys a solution to the issue
  def deny
    @issue = Issue.find(params[:id])
    @issue.resolved = 0
    if @issue.save
      flash[:warning] = "The Solution was Rejected"
      redirect_to project_issue_path(@issue.project_id,@issue.id)
    else
      flash[:error] = "Error in Saving. Please retry."
      redirect_to project_issue_path(@issue.project_id,@issue.id)
    end
  end

  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy
    flash[:notice] = "The Issue was Deleted"
    redirect_to(:controller => "projects", :action => 'show', :id => @issue.project_id)
  end

  def isOwner(project)
    if not (user_signed_in? and (current_user.admin? or (project.user_id and current_user.id == project.user.id)))
      return false
    else
      return true
    end
  end

end










