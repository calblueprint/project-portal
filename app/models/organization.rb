class Organization < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  has_many :questions
  has_one :user, :as => :rolable
  has_many :applications
  has_many :projects, :through => :applications

  attr_accessible :description, :name, :website, :sname, :organization_id
end
