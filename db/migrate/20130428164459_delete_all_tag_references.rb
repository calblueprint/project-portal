class DeleteAllTagReferences < ActiveRecord::Migration
  def up
  	drop_table :all_tags
  	drop_table :tags
  end

  def down
  	create_table :all_tags do |t|
      t.string :tag

      t.timestamps
    end
    create_table :tags do |t|
      t.string :label
      t.integer :issue_id

      t.timestamps
    end
  end
end
