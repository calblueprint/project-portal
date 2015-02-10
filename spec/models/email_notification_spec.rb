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

require 'spec_helper'

describe EmailNotification do
  pending "add some examples to (or delete) #{__FILE__}"
end
