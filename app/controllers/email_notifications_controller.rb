class EmailNotificationsController < ApplicationController
  
  # GET /email_notifications/1/edit
  def edit
    @email_notification = EmailNotification.find(params[:id])
  end


  # PUT /email_notifications/1
  # PUT /email_notifications/1.json
  def update
    @email_notification = EmailNotification.find(params[:id])

    respond_to do |format|
      if @email_notification.update_attributes(params[:email_notification])
        format.html { redirect_to @email_notification, notice: 'Email notification was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @email_notification.errors, status: :unprocessable_entity }
      end
    end
  end
end
