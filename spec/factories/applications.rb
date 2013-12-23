# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :application do
    questions "MyText"
    project_id 1
    organization_id 1
  end
end
