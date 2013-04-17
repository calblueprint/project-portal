namespace :db do
  desc "fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    User.populate 1000 do |person|
      person.fname    = Faker::Name.first_name
      person.lname    = Faker::Name.last_name
      person.encrypted_password = Faker::Name.name
      person.email    = Faker::Internet.email
    end
  end
end