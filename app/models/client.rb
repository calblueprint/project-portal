class Client < ActiveRecord::Base
  attr_accessible :company_name, :company_site, :company_address, :nonprofit,
                  :five_01c3, :mission_statement, :contact_email,
                  :contact_number, :photo
  has_one :user, :as => :rolable
  has_many :projects, :dependent => :destroy
  mount_uploader :photo, PhotoUploader
end
