class IssuesController < ApplicationController
  respond_to :html, :json

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
		@issue = Issue.find(params[:id])
		if @issue.update_attributes(params[:issue])
			flash[:notice] = "Event Updated"
			respond_with @issue
		else
			respond_with_bip(@issue)
		end
	end
end
