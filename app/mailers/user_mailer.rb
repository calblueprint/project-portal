class UserMailer < ActionMailer::Base
  default from: "support@projectportal.com"

  def project_approved(project, comment)
    @project = project
    @comment = comment 
    @user = User.find_by_id(@project.user_id)
    mail(:to => @user.email, :subject => "[Project Portal] Your project has been approved!")
  end

  def project_denied(project, comment)
    @project = project    
    @comment = comment
    @user = User.find_by_id(@project.user_id)
    mail(:to => @user.email, :subject => "[Project Portal] There were some issues with your project.")
  end

  def favorited_project(project, current_user)
    @project = project
    @proj_owner = User.find_by_id(@project.user_id)
    @favoriter = current_user
    mail(:to => @user.email, :subject => "[Project Portal] A New User has Favorited Your Project!")

end
