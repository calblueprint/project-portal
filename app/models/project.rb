class Project < ActiveRecord::Base
  attr_accessible :questions, :title, :nonprofit, :github_site, :company_site, :application_site

  serialize :questions, Hash
  
  QUESTIONS.keys.each do |q|
    attr_accessible q.to_sym
    attr_accessor q.to_sym
  end
  
  before_save :merge_questions 

  def merge_questions
    questions = {}
    QUESTIONS.each do |q|
      questions[q[0]] = self.send(q[0])
    end
    self.questions = questions
  end

end
