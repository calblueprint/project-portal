# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :all_tag, :class => 'AllTags' do
    tag "MyString"
  end
end
