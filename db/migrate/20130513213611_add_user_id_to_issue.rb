class AddUserIdToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :submitter_id, :integer
  end
end
