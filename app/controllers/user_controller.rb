class UserController < ApplicationController
  def show
    if user_signed_in?
      @projects = Project.find_all_by_user_id(current_user.id)
    else
      redirect_to new_user_session_path, notice: 'Please log in to view your dashboard.'
    end
  end
  
  def settings
    @questions = Question.all
    @unapproved_projects = Project.unapproved_projects
    @denied_projects = Project.denied_projects
  end
end
