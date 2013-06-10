# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130610180802) do

  create_table "clients", :force => true do |t|
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "company_name"
    t.string   "company_site"
    t.string   "company_address"
    t.boolean  "nonprofit"
    t.boolean  "five_01c3"
    t.string   "mission_statement"
    t.string   "contact_email"
    t.string   "contact_number"
    t.string   "photo"
  end

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",   :default => 0
    t.string   "commentable_type", :default => ""
    t.string   "title",            :default => ""
    t.text     "body",             :default => ""
    t.string   "subject",          :default => ""
    t.integer  "user_id",          :default => 0,  :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "developers", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "email_notifications", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "fav_projects",    :default => true
    t.boolean  "proj_approval",   :default => true
    t.boolean  "fav_issues",      :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "issues_approval", :default => true
    t.boolean  "resolve_results", :default => true
  end

  add_index "email_notifications", ["user_id"], :name => "index_email_notifications_on_user_id"

  create_table "favorites", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "issues", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "resolved",     :default => 0
    t.string   "project_id",                  :null => false
    t.string   "authors"
    t.string   "github"
    t.integer  "submitter_id"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "website"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "sname"
  end

  create_table "organizations_projects", :id => false, :force => true do |t|
    t.integer "project_id"
    t.integer "organization_id"
  end

  add_index "organizations_projects", ["project_id", "organization_id"], :name => "index_organizations_projects_on_project_id_and_organization_id"

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.text     "questions"
    t.string   "github_site"
    t.string   "application_site"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "user_id"
    t.string   "photo"
    t.string   "slug"
    t.boolean  "approved"
    t.integer  "state"
    t.text     "problem"
    t.string   "short_description"
    t.text     "long_description"
  end

  create_table "projects_users", :id => false, :force => true do |t|
    t.integer "project_id", :null => false
    t.integer "user_id",    :null => false
  end

  create_table "questions", :force => true do |t|
    t.string   "question"
    t.string   "input_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "deleted"
    t.integer  "organization_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "fname"
    t.string   "lname"
    t.integer  "rolable_id"
    t.string   "rolable_type"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
