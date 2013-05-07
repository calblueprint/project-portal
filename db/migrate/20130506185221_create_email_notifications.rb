class CreateEmailNotifications < ActiveRecord::Migration
  def change
    create_table :email_notifications do |t|
      t.references :user
      t.boolean :fav_projects, :default => true
      t.boolean :proj_approval, :default => true
      t.boolean :fav_issues, :default => true

      t.timestamps
    end
    add_index :email_notifications, :user_id
    User.all.each do |user|
      e = EmailNotification.new(:fav_projects => 'true', :proj_approval => 'true', :fav_issues => 'true')
      e.user = user
      e.save
    end
  end
end
