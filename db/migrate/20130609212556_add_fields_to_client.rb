class AddFieldsToClient < ActiveRecord::Migration
  def change
    add_column :clients, :company_name, :string
    add_column :clients, :company_site, :string
    add_column :clients, :company_address, :string
    add_column :clients, :nonprofit, :boolean
    add_column :clients, :five_01c3, :boolean
    add_column :clients, :mission_statement, :string
    add_column :clients, :contact_email, :string
    add_column :clients, :contact_number, :string
  end
end
