class IssuesController < ApplicationController
  #displays a specfic issue	
	def show
		@issue = Issue.find(params[:id])
	end

	#redirects to page where you can specify data about a new issue
	def new
		@title = "Create an Issue"
		#@issue = Event.new
	end
end
