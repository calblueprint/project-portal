class AddDeletedToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :deleted, :string
  end
end
