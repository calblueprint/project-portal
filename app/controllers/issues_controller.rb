class IssuesController < ApplicationController
  respond_to :html, :json

  def index
    @openIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ? AND project_id = ?", 0, params[:proj_id]], :order => "created_at")
    @pendingIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ? AND project_id = ?", 1, params[:proj_id]], :order => "created_at")
    @resolvedIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ? AND project_id = ?", 2, params[:proj_id]], :order => "created_at")
  end

    #displays a specfic issue 
  def show
    @issue = Issue.find(params[:id])
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
      flash[:notice] = "Issue Added"
      redirect_to(:action => 'show', :id => @issue)
    else
      render action: "new"
    end
  end

  #saves the changes
  def update
    #TODO: make sure company can only edit theirs!
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
    if @issue.save
      flash[:notice] = "Solution Submitted"
      redirect_to(:action => 'show', :id => @issue)
    else
      redirect_to(:action => 'show', :id => @issue)
    end
  end

  #when the company accepts a solution to the issue
  def accept
    @issue = Issue.find(params[:id])
    @issue.resolved = 2
    if @issue.save
      flash[:notice] = "Soution Accepted"
      redirect_to(:action => 'show', :id => @issue)
    else
      redirect_to(:action => 'show', :id => @issue)
    end
  end

  #when the company denys a solution to the issue
  def deny
    @issue = Issue.find(params[:id])
    @issue.resolved = 0
    if @issue.save
      flash[:notice] = "Soution Denyed"
      redirect_to(:action => 'show', :id => @issue)
    else
      redirect_to(:action => 'show', :id => @issue)
    end
  end
end










