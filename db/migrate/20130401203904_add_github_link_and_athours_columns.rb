class AddGithubLinkAndAthoursColumns < ActiveRecord::Migration
  def up
  	add_column :issues, :authors, :string
  	add_column :issues, :github, :string
  end

  def down
  	remove_column :issues, :authors
  	remove_column :issues, :github
  end
end
