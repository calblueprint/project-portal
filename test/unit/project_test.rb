# == Schema Information
#
# Table name: projects
#
#  id                :integer          not null, primary key
#  title             :string(255)
#  questions         :text
#  github_site       :string(255)
#  application_site  :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  client_id         :integer
#  photo             :string(255)
#  slug              :string(255)
#  approved          :boolean
#  state             :integer
#  problem           :text
#  short_description :string(255)
#  long_description  :text
#  comment           :text
#

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
