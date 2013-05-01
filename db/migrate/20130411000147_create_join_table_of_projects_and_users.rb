class CreateJoinTableOfProjectsAndUsers < ActiveRecord::Migration
  def up
    create_table :projects_users, :id => false do |t|
      t.references :project, :null => false
      t.references :user, :null => false
    end
  end

  def down
    drop_table :projects_users
  end
end
