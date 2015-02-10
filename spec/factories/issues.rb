# == Schema Information
#
# Table name: issues
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  resolved     :integer          default(0)
#  project_id   :integer          not null
#  authors      :string(255)
#  github       :string(255)
#  submitter_id :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :issue do
    title "MyString"
    description "MyText"
    resolved false
  end
end
