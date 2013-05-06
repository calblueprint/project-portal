class EmailNotification < ActiveRecord::Base
  belongs_to :user
  attr_accessible :fav_issues, :fav_projects, :proj_approval
end
