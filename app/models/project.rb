class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
    
  belongs_to :user
  has_many :issues
  
  attr_accessible :questions, :title, :nonprofit, :five_01c3, :github_site, :company_site, :company_address, 
  :application_site, :mission_statement, :contact_name, :contact_position, :contact_email, :contact_number, :contact_hours, :photo, :company_name
  
  validates :title, :company_site, :company_address, :company_name,
  :mission_statement, :contact_name, :contact_position, :contact_email, :contact_number, 
  :contact_hours, :presence => true
  validates :title, :mission_statement, :length => { :minimum => 4 }
  validates :title, :github_site, :application_site, :uniqueness => true, :allow_blank => true

  # validate URLs
  validates :company_site, :github_site, :allow_blank => true,
  :format => /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/ # regex from http://blog.mattheworiordan.com/post/13174566389/url-regular-expression-for-links-with-or-without-the

  # method from StackOverflow (http://stackoverflow.com/questions/7167895/whats-a-good-way-to-validate-links-urls-in-rails-3)
  # URI::regexp(%w(http https))

  # validate emails, regex from StackOverflow (http://stackoverflow.com/questions/201323/using-a-regular-expression-to-validate-an-email-address)
  validates_format_of :contact_email, :with => /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/
  
  serialize :questions, Hash
  before_save :merge_questions 
  mount_uploader :photo, PhotoUploader
  
  def merge_questions
    questions = {}
    Question.all.each do |q|
      questions[Project.question_key(q)] = self.send(Project.question_key(q))
    end
    self.questions = questions
  end

  # Class Methods for questions as virtual attributes
  def self.question_key(q)
    "question_#{q.id}".to_sym
  end
  
  def self.get_question_id(q)
    q[0].to_s.split("_")[-1]
  end
  
  # add all Questions as virtual attributes for the Project model
  def self.virtualize_questions
    Question.all.each do |q|
      attr_accessible question_key(q)
      attr_accessor question_key(q)
    end
  end
  
  
  Project.virtualize_questions
end

