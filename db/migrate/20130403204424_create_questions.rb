class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :question
      t.string :subject
      t.string :input_type

      t.timestamps
    end
  end
end
