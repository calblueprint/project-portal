class EmailNotificationsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /email_notifications/1/edit
  def edit
    @email_notification = EmailNotification.find(params[:id])
  end


  # PUT /email_notifications/1
  # PUT /email_notifications/1.json
  def update
    @email_notification = EmailNotification.find(params[:id])

    if @email_notification.update_attributes(params[:email_notification])
      redirect_to edit_user_registration_path, :notice => "Your email notification settings have been successfully updated."
    else
      redirect_to edit_user_registration_path, :warning => "There was an issue with updating your email notification settings."
    end
  end
end
