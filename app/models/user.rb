class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :fname, :lname, :email, :password, :password_confirmation, :remember_me, :admin
  # attr_accessible :title, :body

  validates :fname, :lname, :email, :password, :presence => true
  
  has_many :projects, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :favorite_projects, :through => :favorites, :source => :project
end
