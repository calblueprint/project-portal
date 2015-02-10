# == Schema Information
#
# Table name: developers
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Developer < ActiveRecord::Base
  has_one :user, :as => :rolable
  #should add profile picture
end
