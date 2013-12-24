class Organization < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  has_many :questions
  has_one :user, :as => :rolable
  has_many :applications
  has_many :projects, :through => :applications

  attr_accessible :description, :name, :website, :sname, :organization_id

  scope :not_applied, lambda { |project|
    where("id NOT IN (?)", Organization.joins(:applications).where("applications.project_id = ?", project.id) )
  }

  scope :is_public, lambda { Project.where("id not in (?)", Project.joins(:organizations)) }
end
