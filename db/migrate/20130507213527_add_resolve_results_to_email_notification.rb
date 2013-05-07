class AddResolveResultsToEmailNotification < ActiveRecord::Migration
  def change
    add_column :email_notifications, :resolve_results, :boolean, :default => true
    EmailNotification.update_all(:resolve_results => true)
  end
end
