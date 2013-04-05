class AddCompanyNameToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :company_name, :string
  end
end
