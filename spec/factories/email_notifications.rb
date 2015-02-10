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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email_notification do
    user nil
    fav_projects false
    proj_approval false
    fav_issues false
  end
end
