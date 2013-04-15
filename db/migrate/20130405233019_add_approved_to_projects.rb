class AddApprovedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :approved, :boolean
  end
end
