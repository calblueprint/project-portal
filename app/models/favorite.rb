class Favorite < ActiveRecord::Base
  attr_accessible :title, :body, :project
  belongs_to :user
  belongs_to :project
  validates_uniqueness_of :user_id, :scope => [:project_id]
end
