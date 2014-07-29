class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.text :questions
      t.integer :project_id
      t.integer :organization_id

      t.timestamps
    end
  end
end
