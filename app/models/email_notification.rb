class EmailNotification < ActiveRecord::Base
  belongs_to :user
  attr_accessible :fav_issues, :fav_projects, :proj_approval, :issues_approval, :resolve_results
  validates_uniqueness_of :user_id
end
