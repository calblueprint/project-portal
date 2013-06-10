class AddOrganizationIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :organization_id, :integer
  end
end
