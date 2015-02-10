# == Schema Information
#
# Table name: clients
#
#  id                 :integer          not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  company_name       :string(255)
#  company_site       :string(255)
#  company_address    :string(255)
#  nonprofit          :boolean
#  five_01c3          :boolean
#  mission_statement  :string(255)
#  contact_email      :string(255)
#  contact_number     :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#

class Client < ActiveRecord::Base
  attr_accessible :company_name, :company_site, :company_address, :nonprofit, :five_01c3, :mission_statement, :contact_email, :contact_number, :photo
  has_one :user, :as => :rolable
  has_many :projects, :dependent => :destroy
  has_attached_file :photo,
    :storage => :s3,
    :s3_credentials => S3_CREDENTIALS,
    :path => "/projects/:style/:id/:filename",
    :styles => { :medium => "400px>" }
end
