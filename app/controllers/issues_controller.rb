class IssuesController < ApplicationController
  def index
		@title = "HOMEE"
	end

  #displays a specfic issue	
	def show
		@issue = Issue.find(params[:id])
	end

	#redirects to page where you can specify data about a new issue
	def new
		@title = "Create an Issue"
		@issue = Issue.new
		#@issue.resolved = false
	end

	#actually creates a new event
	def create
		@issue = Issue.new(params[:id])
		@issue.resolved = false
		@issue.title = params[:issue][:title]
		@issue.description = params[:issue][:description]

	    if @issue.save
	      flash[:notice] = "Issue Added"
	      redirect_to(:action => 'show')
	    else
	      render action: "new"
	    end
	end
end
