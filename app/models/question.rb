class Question < ActiveRecord::Base
  attr_accessible :input_type, :question
  
  
  def self.current_questions
    Question.where(:deleted => [nil, false, 'f'])
  end
  
  # Creates virtual attributes for all questions for a Project instance
  after_save :virtual_project_attr
  private
  def virtual_project_attr
    Project.virtualize_questions
  end
end
