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

u = User.create({
  fname: "User",
  lname: "User",
  admin: false,
  email: "user@user.com",
  password: "password"
  })
u.confirmed_at = Time.now
u.save

Organization.create({
  sname: 'cs169',
  name: "UC Berkeley CS169 Software Engineering Course",
  email: "pattrsn@eecs.berkeley.edu",
  password: "ucbsaas",
  description: "Over the course of a semester, students complete a course project in teams of four or five. Groups will be assigned to an external customer from a campus or non-profit organization to build a SaaS application.",
  website: "https://sites.google.com/site/ucbsaas/",
})

Organization.create({
  sname: 'blueprint',
  name: "Blueprint, Technology for Non-Profits",
  email: "calblueprint@gmail.com",
  password: "beautifulengineering",
  description: "Our mission is to make beautiful engineering accessible and useful for those who create communities and promote public welfare.",
  website: "http://bptech.berkeley.edu",
})

# Project.create({
#   github_site: "https://github.com/callmemc/altbreaks",
#   application_site: "http://publicservice.berkeley.edu/alternativebreaks",
#   title: "Internal Forum",
#   nonprofit: true,
#   five_01c3: true,
#   company_name: "Alternative Breaks",
#   company_site: "http://publicservice.berkeley.edu/alternativebreaks",
#   company_address: "102 Sproul Hall",
#   mission_statement: "Alternative Breaks is a service-learning program for students to explore social issues through meaningful service, education, and reflection during their academic breaks. This year, Alternative Breaks offers ten week-long trips coupled with a semester long academic course on issues such as environmental justice, health care, immigration, and homelessness. Students serve throughout California, and in Oregon, Arizona and Louisiana.",
#   contact_name: "Kati Hinman",
#   contact_position: "Director",
#   contact_email: "kati.hinman@gmail.com",
#   contact_number: "123-456-789",
#   contact_hours: "M-F 9-5 pm",
#   })

