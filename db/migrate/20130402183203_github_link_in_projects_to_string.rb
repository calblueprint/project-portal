class GithubLinkInProjectsToString < ActiveRecord::Migration
  def up
  	change_column :projects, :github_site, :string
  end

  def down
  	change_column :projects, :github_site, :text
  end
end
