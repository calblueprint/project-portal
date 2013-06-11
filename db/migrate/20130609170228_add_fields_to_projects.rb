class AddFieldsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :problem, :text
    add_column :projects, :short_description, :string
    add_column :projects, :long_description, :text
  end
end
