class UserMailer < ActionMailer::Base
  default from: "support@projectportal.com"

  def project_approved(project)
    @project = project 
    @user = User.find_by_id(@project.user_id)
    mail(:to => @user.email, :subject => "[Project Portal] Your project has been approved!")
  end

  def project_denied(project, comment)
    @project = project    
    @comment = comment
    @user = User.find_by_id(@project.user_id)
    mail(:to => @user.email, :subject => "[Project Portal] There were some issues with your project.")
  end
end
