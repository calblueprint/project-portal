class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|    
      t.integer :project_id
      t.integer :user_id
      #add_index :favorites, [:project_id, :user_id], :unique => true
      t.timestamps
    end
  end
end
