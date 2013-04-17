namespace :db do
  desc "fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    User.populate 500 do |person|
      person.fname    = Faker::Name.first_name
      person.lname    = Faker::Name.last_name
      person.encrypted_password = Faker::Name.name
      person.email    = Faker::Internet.email
    end
    
    Project.populate 50 do |p|
      p.title             = Faker::Lorem.sentence
      p.company_name      = Faker::Name.name
      p.company_site      = Faker::Internet.url
      p.company_address   = Faker::Address.city
      p.mission_statement = Faker::Lorem.paragraph
      p.contact_name      = Faker::Name.name
      p.contact_position  = Faker::Lorem.word
      p.contact_number    = Faker::PhoneNumber.phone_number
      p.contact_email     = Faker::Internet.email
      p.contact_hours     = Faker::Name.first_name
      p.user_id           = 1
    end
  end
end