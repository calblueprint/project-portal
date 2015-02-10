# == Schema Information
#
# Table name: organizations
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  website     :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  sname       :string(255)
#

class Organization < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  has_and_belongs_to_many :projects
  has_many :questions
  has_one :user, :as => :rolable

  attr_accessible :description, :name, :website, :sname, :organization_id
end
