class AddRolableTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rolable_id, :integer 
    add_column :users, :rolable_type, :string 
  end
end
