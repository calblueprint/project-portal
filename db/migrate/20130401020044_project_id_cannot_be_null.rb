class ProjectIdCannotBeNull < ActiveRecord::Migration
  def up
  	change_column :issues, :project_id, :integer, :null => false
  end

  def down
  	change_column :issues, :project_id, :integer, :null => true
  end
end
