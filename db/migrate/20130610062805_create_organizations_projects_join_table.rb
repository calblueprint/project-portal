class CreateOrganizationsProjectsJoinTable < ActiveRecord::Migration
  def up
    create_table :organizations_projects, :id => false do |t|
      t.integer :project_id
      t.integer :organization_id
    end

    add_index :organizations_projects, [:project_id, :organization_id]
  end

  def down
    drop_table :organizations_projects

  end
end
