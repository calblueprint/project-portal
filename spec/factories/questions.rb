# == Schema Information
#
# Table name: questions
#
#  id              :integer          not null, primary key
#  question        :string(255)
#  input_type      :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  deleted         :string(255)
#  organization_id :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    question "MyString"
    subject "MyString"
    input_type "MyString"
  end
end
