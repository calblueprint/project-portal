class IssuesController < ApplicationController
  respond_to :html, :json

  def index
		@openIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ?", 0], :order => "created_at")
		@pendingIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ?", 1], :order => "created_at")
		@resolvedIssues = Issue.find(:all, :limit => 10, :conditions => ["resolved = ?", 2], :order => "created_at")
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
		@issue.resolved = false
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
end
