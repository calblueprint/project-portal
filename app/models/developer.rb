class Developer < ActiveRecord::Base
  has_one :user, :as => :rolable
  #should add profile picture
end
