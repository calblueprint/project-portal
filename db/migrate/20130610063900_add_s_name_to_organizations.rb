class AddSNameToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :sname, :string
  end
end
