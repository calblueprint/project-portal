class Project < ActiveRecord::Base

  # class constants, integer so as to allow for more states in the future
  UNFINISHED = 1
  FINISHED = 2
  
  extend FriendlyId
  friendly_id :title, use: :slugged
    
  belongs_to :user
  has_many :issues
  
  attr_accessible :questions, :title, :nonprofit, :five_01c3, :github_site, :company_site, :company_address, 
  :application_site, :mission_statement, :contact_name, :contact_position, :contact_email, :contact_number, 
  :contact_hours, :photo, :company_name, :approved, :comment, :state
  
  attr_accessor :comment
  
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

  scope :by_title, lambda { |search_string|
    if not search_string.empty?
      where('title like ?', "%#{search_string}%")
    end
  } 

  scope :by_organization, lambda { |org|
     if not org.empty?
       where('company_name like ?', "%#{org}%")
     end
  }

  scope :is_nonprofit, lambda { |is_nonprofit|
    if is_nonprofit
      where(:nonprofit => is_nonprofit)
    end
  } 
  
  scope :is_forprofit, lambda { |is_nonprofit|
    if is_nonprofit
      where(:nonprofit => false) 
    end
  } 

  scope :is_five_01c3, lambda { |is_five_01c3|
    if is_five_01c3
      where(:five_01c3 => is_five_01c3)
    end
  }  
  
  scope :by_title_organization, lambda {|search|
    project = Project.arel_table
    where(project[:title].matches("%#{search}%").or(project[:company_name].matches("%#{search}%"))) if search
  }
  
  scope :is_finished, lambda { |is_finished|
    where(:state => Project::FINISHED) if is_finished
  }

  def self.search(params, admin)
    if admin
      Project.is_nonprofit(params.has_key?('nonprofit'))
      .is_five_01c3(params.has_key?('five_01c3'))
      .is_forprofit(params.has_key?('forprofit'))
      .by_title_organization(params['search_string'])
      .is_finished(params['state'])
    else
      Project.where(:approved => true)
      .is_nonprofit(params.has_key?('nonprofit'))
      .is_five_01c3(params.has_key?('five_01c3'))
      .is_forprofit(params.has_key?('forprofit'))
      .by_title_organization(params['search_string'])
      .is_finished(params['state'])
    end
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
  
  def self.unapproved_projects
    Project.where(:approved => nil)
  end
  
  def self.denied_projects
    Project.where(:approved => false)
  end
  
  Project.virtualize_questions
end

