# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Question.create([
  { question: "If selected, is the contact listed above available to speak on a weekly basis with a student from CS169?", 
    input_type: "text"
  },
  { question: "If selected, will you and your organization fully commit to an engagement with CS169 for 8 weeks in Fall 2012?",
    input_type: "text"
  },
  { question: "Does the contact above have the ability to implement software solutions developed by the CS169 team?",
    input_type: "text"
  }
])
u = User.create({
  fname: "Admin",
  lname: "Admin",
  admin: true,
  email: "admin@admin.com",
  password: "password"
  })
u.confirmed_at = Time.now  
u.save


