class Question < ActiveRecord::Base
  attr_accessible :input_type, :question
  
  after_save :virtual_project_attr
  
  
  private
  def virtual_project_attr
    Project.virtualize_questions
  end
end
