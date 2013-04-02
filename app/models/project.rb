class Project < ActiveRecord::Base
  attr_accessible :questions, :title, :nonprofit, :five_01c3, :github_site, :company_site, :company_address,
  :application_site, :mission_statement, :contact_name, :contact_position, :contact_email, :contact_number, :contact_hours
  belongs_to :user
  has_many :issues


  validates :title, :github_site, :company_site, :company_address,
  :application_site, :mission_statement, :contact_name, :contact_position, :contact_email, :contact_number, 
  :contact_hours, :presence => true
  validates :title, :mission_statement, :length => { :minimum => 4 }
  validates :title, :github_site, :application_site, :uniqueness => true

  # validate URLs
  validates :company_site, :github_site, :format => /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/ # regex from http://blog.mattheworiordan.com/post/13174566389/url-regular-expression-for-links-with-or-without-the

  # method from StackOverflow (http://stackoverflow.com/questions/7167895/whats-a-good-way-to-validate-links-urls-in-rails-3)
  # URI::regexp(%w(http https))


  # validate emails, regex from StackOverflow (http://stackoverflow.com/questions/201323/using-a-regular-expression-to-validate-an-email-address)
  validates_format_of :contact_email, :with => /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/
  
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
