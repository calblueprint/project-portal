class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string  :title
      t.text    :description
      t.string  :github_site
      t.string  :company_site
      t.string  :application_site
      t.boolean :nonprofit

      t.timestamps
    end
  end
end
