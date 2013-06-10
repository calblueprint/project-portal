class RemoveDeviseFromOrganizations < ActiveRecord::Migration
  def up
    remove_column :organizations, :email
    remove_column :organizations, :encrypted_password
    remove_column :organizations, :reset_password_token
    remove_column :organizations, :reset_password_sent_at
    remove_column :organizations, :remember_created_at
    remove_column :organizations, :sign_in_count
    remove_column :organizations, :current_sign_in_at
    remove_column :organizations, :last_sign_in_at
    remove_column :organizations, :current_sign_in_ip
    remove_column :organizations, :last_sign_in_ip

    # remove_index :organizations, :email
    # remove_index :organizations, :reset_password_token
  end

  def down
    add_column :organizations, :last_sign_in_ip, :string
    add_column :organizations, :current_sign_in_ip, :string
    add_column :organizations, :last_sign_in_at, :datetime
    add_column :organizations, :current_sign_in_at, :datetime
    add_column :organizations, :sign_in_count, :integer
    add_column :organizations, :remember_created_at, :datetime
    add_column :organizations, :reset_password_sent_at, :datetime
    add_column :organizations, :reset_password_token, :string
    add_column :organizations, :encrypted_password, :string
    add_column :organizations, :email, :string

    # add_index :organizations, :email,                :unique => true
    # add_index :organizations, :reset_password_token, :unique => true
  end
end
