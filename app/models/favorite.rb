# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  project_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Favorite < ActiveRecord::Base
  attr_accessible :title, :body, :project
  belongs_to :user
  belongs_to :project
  validates_uniqueness_of :user_id, :scope => [:project_id]
end
