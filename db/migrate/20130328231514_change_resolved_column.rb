class ChangeResolvedColumn < ActiveRecord::Migration
  def up
  	remove_column :issues, :resolved
  	add_column :issues, :resolved, :integer, :default => 0
  end

  def down
  	remove_column :issues, :resolved
  	add_column :issues, :resolved, :boolean
  end
end
