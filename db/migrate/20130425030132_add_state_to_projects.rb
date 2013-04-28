class AddStateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :state, :integer
    Project.update_all(:state => Project::UNFINISHED)
  end
end
