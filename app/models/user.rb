# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  admin                  :boolean          default(FALSE)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  fname                  :string(255)
#  lname                  :string(255)
#  rolable_id             :integer
#  rolable_type           :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :fname, :lname, :email, :password, :password_confirmation, :remember_me, :admin, :rolable_type
  # attr_accessible :title, :body

  validates :fname, :lname, :email, :presence => true
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password

  belongs_to :rolable, :polymorphic => true
  # has_many :projects, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :favorite_projects, :through => :favorites, :source => :project
  has_one :email_notification, :dependent => :destroy

  after_create :add_email_notifs

  def add_email_notifs
    e = EmailNotification.new
    e.user = self
    e.save
  end

end
