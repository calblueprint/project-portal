class Favorite < ActiveRecord::Base
  attr_accessible :title, :body, :project
  belongs_to :user
  belongs_to :project
end
