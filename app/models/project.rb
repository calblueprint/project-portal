require 'will_paginate/array'

class Project < ActiveRecord::Base
  acts_as_commentable

  # class constants, integer so as to allow for more states in the future
  UNFINISHED = 1
  FINISHED = 2

  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :client
  has_many   :issues
  has_many   :favorites, :dependent => :destroy
  has_many   :favorited, :through => :favorites, :source => :user
  has_and_belongs_to_many :favorite_users, :class_name => "User"
  has_and_belongs_to_many :organizations

  attr_accessible :github_site, :application_site#, :as => [:default, :admin, :owner]
  attr_accessible :questions, :title, :comment, :state#, :as => [ :owner, :admin ]
  attr_accessible :problem, :short_description, :long_description#, :as => [ :owner, :admin ]
  attr_accessible :approved, :as => :admin
  attr_accessor :project_params, :org_params
  attr_accessible :organization

  attr_accessible :user_id, :as=>:admin

  validates :title, :presence => true
  # validates :title, :mission_statement, :length => { :minimum => 4 }
  validates :title, :github_site, :application_site, :uniqueness => true, :allow_blank => true

  # validate URLs
  validates :github_site, :allow_blank => true, :format => /(((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/ #simplified version
 # :company_site,

  #/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/ # regex from http://blog.mattheworiordan.com/post/13174566389/url-regular-expression-for-links-with-or-without-the

  # method from StackOverflow (http://stackoverflow.com/questions/7167895/whats-a-good-way-to-validate-links-urls-in-rails-3)

  # validate emails, regex from StackOverflow (http://stackoverflow.com/questions/201323/using-a-regular-expression-to-validate-an-email-address)
  # validates_format_of :contact_email, :with => /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/

  serialize :questions, Hash
  before_save :merge_questions
  # mount_uploader :photo, PhotoUploader

  scope :by_title, lambda { |search_string|
    if not search_string.empty?
      where('title like ?', "%#{search_string}%")
    end
  }

  scope :by_organization, lambda { |org|
     if not org.empty?
       joins(:client).where('clients.company_name like ?', "%#{org}%")
     end
  }

  scope :is_nonprofit, lambda { |is_nonprofit|
    if is_nonprofit
      joins(:client).where(:clients => {:nonprofit => is_nonprofit})
    end
  }

  scope :is_forprofit, lambda { |is_nonprofit|
    if is_nonprofit
      joins(:client).where(:clients => {:nonprofit => false})
    end
  }

  scope :is_five_01c3, lambda { |is_five_01c3|
    if is_five_01c3
      joins(:client).where(:clients => {:five_01c3 => is_five_01c3})
    end
  }

  scope :by_title_organization, lambda {|search|
    # project = Project.arel_table
    if search
      by_organization(search)
    end
    # where(project[:title].matches("%#{search}%").or(project.client[:company_name].matches("%#{search}%"))) if search
  }

  scope :is_finished, lambda { |is_finished|
    where(:state => Project::FINISHED) if is_finished
  }

  def self.search(params, admin)
    # if admin
      initial = Project.is_nonprofit(params.has_key?('nonprofit'))
      .is_five_01c3(params.has_key?('five_01c3'))
      .is_forprofit(params.has_key?('forprofit'))
      .is_finished(params['state'])

      initial.by_organization(params['search_string']).push(initial.by_title(params['search_string'])).flatten.uniq
    # else
    #   Project.where(:approved => true)
    #   .is_nonprofit(params.has_key?('nonprofit'))
    #   .is_five_01c3(params.has_key?('five_01c3'))
    #   .is_forprofit(params.has_key?('forprofit'))
    #   .by_title_organization(params['search_string'])
    #   .is_finished(params['state'])
    # end
  end

  def merge_questions
    updated_questions = questions.blank? ? {} : questions
    if project_questions != nil
      project_questions.each do |q|
        question_key = Project.question_key(q)
        question = self.send(question_key)
        updated_questions[question_key] = question unless questions[question_key] == question or question.nil?
      end
      self.questions = updated_questions
    end
  end

  def project_questions
    project_questions = Question.where(:id => questions.map { |q| Project.get_question_id(q)}) unless questions.blank?
    # project_questions = Question.current_questions if project_questions.blank?
    project_questions
  end

  def owner
    client
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
      attr_accessible question_key(q), :as => [:owner, :admin]
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

