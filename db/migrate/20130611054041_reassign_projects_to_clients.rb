class ReassignProjectsToClients < ActiveRecord::Migration
  def up
    rename_column :projects, :user_id, :client_id
  end
  def down
    rename_column :projects, :client_id, :user_id
  end
end
