class ChangeDefaultValueForIssuesApprovalAndFavIssuesToEmailNotification < ActiveRecord::Migration
  def change
    change_column :email_notifications, :issues_approval, :boolean, :default => true
    change_column :email_notifications, :fav_issues, :boolean, :default => false
    EmailNotification.update_all(:fav_issues => false)
  end
end
