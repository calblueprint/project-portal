# == Schema Information
#
# Table name: questions
#
#  id              :integer          not null, primary key
#  question        :string(255)
#  input_type      :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  deleted         :string(255)
#  organization_id :integer
#

class Question < ActiveRecord::Base
  attr_accessible :input_type, :question, :organization
  belongs_to :organization

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
