# == Schema Information
#
# Table name: organizations
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  website     :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  sname       :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name "MyString"
    description "MyText"
    website "MyString"
  end
end
