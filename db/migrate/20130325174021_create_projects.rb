class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string  :title
      t.text    :questions
      t.string  :github_site
      t.string  :company_site
      t.string  :company_address
      t.string  :application_site
      t.boolean :nonprofit
      t.boolean :five_01c3
      t.string  :mission_statement
      t.string  :contact_name
      t.string  :contact_position
      t.string  :contact_number
      t.string  :contact_email
      t.string  :contact_hours
      

      t.timestamps
    end
  end
end
