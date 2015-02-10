# == Schema Information
#
# Table name: email_notifications
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  fav_projects    :boolean          default(TRUE)
#  proj_approval   :boolean          default(TRUE)
#  fav_issues      :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  issues_approval :boolean          default(TRUE)
#  resolve_results :boolean          default(TRUE)
#

class EmailNotification < ActiveRecord::Base
  belongs_to :user
  attr_accessible :fav_issues, :fav_projects, :proj_approval, :issues_approval, :resolve_results
  validates_uniqueness_of :user_id
end
