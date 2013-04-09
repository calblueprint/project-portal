class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :label
      t.integer :issue_id

      t.timestamps
    end
  end
end
