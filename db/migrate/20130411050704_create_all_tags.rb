class CreateAllTags < ActiveRecord::Migration
  def change
    create_table :all_tags do |t|
      t.string :tag

      t.timestamps
    end
  end
end
