# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#ADMIN-------------------------------
u = User.create({
  fname: "Admin",
  lname: "Admin",
  admin: true,
  email: "admin@admin.com",
  password: "password"
  })
u.confirmed_at = Time.now
u.save

#DEVELOPER
mc_user = User.create({
  fname: "Michelle",
  lname: "Chow",
  admin: false,
  email: "callmemc@gmail.com",
  password: "password"
  })
mc_user.confirmed_at = Time.now
mc_user.save
mc = Developer.create
mc_user.rolable = mc
mc_user.rolable_type = mc.class.name
mc_user.save


#ORGANIZATION: CS169------------------------
cs169_user = User.create({
  fname: "David",
  lname: "Patterson",
  admin: false,
  email: "pattrsn@eecs.berkeley.edu",
  password: "password",
  })
cs169_user.confirmed_at = Time.now
cs169_user.save
cs169 = Organization.create({
  sname: 'cs169',
  name: "UC Berkeley CS169 Software Engineering Course",
  description: "Over the course of a semester, students complete a course project in teams of four or five. Groups will be assigned to an external customer from a campus or non-profit organization to build a SaaS application.",
  website: "https://sites.google.com/site/ucbsaas/",
})
cs169_user.rolable = cs169
cs169_user.rolable_type = cs169.class.name
cs169_user.save

cs169_questions = Question.create([
  { question: "If selected, is the contact listed above available to speak on a weekly basis with a student from CS169?",
    input_type: "boolean"
  },
  { question: "If selected, will you and your organization fully commit to an engagement with CS169 for 8 weeks in Fall 2013?",
    input_type: "boolean"
  },
  { question: "Does the contact above have the ability to implement software solutions developed by the CS169 team?",
    input_type: "boolean"
  },
  { question: "Is this a software project?",
    input_type: "boolean"
  }
])
cs169.questions << cs169_questions

#ORGANIZATION: BLUEPRINT------------------------
bp_user = User.create({
  fname: "Kevin",
  lname: "Gong",
  admin: false,
  email: "calblueprint@gmail.com",
  password: "password",
  })
bp_user.confirmed_at = Time.now
bp_user.save
bp = Organization.create({
  sname: 'blueprint',
  name: "Blueprint, Technology for Non-Profits",
  description: "Our mission is to make beautiful engineering accessible and useful for those who create communities and promote public welfare.",
  website: "http://bptech.berkeley.edu",
})

bp_user.rolable = bp
bp_user.rolable_type = bp.class.name
bp_user.save

bp_questions = Question.create([
  { question: "Do you have the technical capabilities to deploy any solutions that Blueprint makes? (eg if Blueprint makes a website, will you be able to set up the domain name and server? Or will you require assistance from the Blueprint team?)",
    input_type: "boolean"
  },
  { question: "If selected, will you and your organization fully commit to an engagement with Blueprint for 11 weeks in Fall 2013?",
    input_type: "boolean"
  },
  { question: " If selected, will a representative of your company be available to meet at two-week intervals with the project team that Blueprint assigns to you?",
    input_type: "boolean"
  }
])
bp.questions << bp_questions

#CLIENT: ALTBREAKS-------------------------
altbreaks_user = User.create({
  fname: "Kati",
  lname: "Hinman",
  admin: false,
  email: "kati.hinman@gmail.com",
  password: "password"
  })
altbreaks_user.confirmed_at = Time.now
altbreaks_user.save
altbreaks = Client.create({
  company_name: 'Alternative Breaks',
  company_site:'http://publicservice.berkeley.edu/alternativebreaks',
  company_address: '102 Sproul Hall, Berkeley, CA 94720',
  nonprofit: true,
  five_01c3: true,
  mission_statement: 'Alternative Breaks is a service-learning program for students to explore social issues through meaningful service, education, and reflection during their academic breaks.',
  contact_email: 'kati.hinman@gmail.com',
  contact_number: '123-456-789'
  })
altbreaks_user.rolable = altbreaks
altbreaks_user.rolable_type = altbreaks.class.name
altbreaks_user.save

#PROJECT: ALTBREAKS SITE-------------------------
proj = Project.create({
  title: "AltBreaks Site",
  github_site: "https://github.com/callmemc/altbreaks",
  application_site: "http://publicservice.berkeley.edu/alternativebreaks",
  short_description: "Mulipurpose website that serves both marketing purposes and internal purposes",
  long_description: "We want an interactive map to show all the trips, so that if you hover over a trip location, a pop-up is displayed with the trip information. We also want trip pages. And we want an internal forum where people from trips can communicate with each other and with people from other trips.",
  })
proj.client = altbreaks
proj.save
# questions: {'question_1' => true, 'question_2' => true, 'question_3' => true}

