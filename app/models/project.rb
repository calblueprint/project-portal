class Project < ActiveRecord::Base
  attr_accessible :questions, :title, :nonprofit, :github_site, :company_site, :application_site, :avail_weekly

  attr_accessor :avail_weekly

  
  QUESTIONS.keys.each do |q|
    attr_accessible q.to_sym
    attr_accessor q.to_sym
  end
  
  before_save :merge_questions
  
  


  def merge_questions
    QUESTIONS.each do |q|
      #do something
      p self.send(q)
    end
  end

end
