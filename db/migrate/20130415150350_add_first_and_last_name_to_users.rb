class AddFirstAndLastNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fname, :string
    add_column :users, :lname, :string
    User.update_all(:fname => "John", :lname => "Doe")
  end
end
