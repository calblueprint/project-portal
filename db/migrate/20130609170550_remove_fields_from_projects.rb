class RemoveFieldsFromProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :company_site
    remove_column :projects, :company_address
    remove_column :projects, :nonprofit
    remove_column :projects, :five_01c3
    remove_column :projects, :mission_statement
    remove_column :projects, :contact_name
    remove_column :projects, :contact_position
    remove_column :projects, :contact_number
    remove_column :projects, :contact_email
    remove_column :projects, :contact_hours
    remove_column :projects, :company_name
  end

  def down
    add_column :projects, :company_name, :string
    add_column :projects, :contact_hours, :string
    add_column :projects, :contact_email, :string
    add_column :projects, :contact_number, :string
    add_column :projects, :contact_position, :string
    add_column :projects, :contact_name, :string
    add_column :projects, :mission_statement, :string
    add_column :projects, :five_01c3, :boolean
    add_column :projects, :nonprofit, :boolean
    add_column :projects, :company_address, :string
    add_column :projects, :company_site, :string
  end
end
