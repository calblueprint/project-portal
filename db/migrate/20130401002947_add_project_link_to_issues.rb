class AddProjectLinkToIssues < ActiveRecord::Migration
  def change
  	add_column :issues, :project_id, :integer
  end
end
