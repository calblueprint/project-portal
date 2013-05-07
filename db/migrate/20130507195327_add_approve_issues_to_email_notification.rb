class AddApproveIssuesToEmailNotification < ActiveRecord::Migration
  def change
    add_column :email_notifications, :issues_approval, :boolean
    EmailNotification.update_all(:issues_approval => true)
  end
end
