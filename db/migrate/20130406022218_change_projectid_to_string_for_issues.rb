class ChangeProjectidToStringForIssues < ActiveRecord::Migration
  def up
  	change_column :issues, :project_id, :integer
  end

  def down
  	change_column :issues, :project_id, :integer
  end
end
