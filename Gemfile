Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development, :test do
  gem 'sqlite3'
  gem 'factory_girl_rails', '~>2.0'
  gem 'launchy'
  gem 'rspec-rails'
end


group :production do
  gem 'pg'
  gem 'thin'
  gem 'rmagick', '2.13.2'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'twitter-bootstrap-rails'
gem 'best_in_place'
#for adding comments to projects
gem 'acts_as_commentable_with_threading'
gem 'rails_autolink'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
#  gem 'debugger'

group :test do
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'simplecov'
end

# our app specific gems
gem 'bootstrap-sass'
gem 'jquery-rails'
gem 'haml'
gem 'devise'
gem 'simple_form'
gem 'carrierwave'
gem 'friendly_id'
gem 'populator'
gem 'faker'
gem 'will_paginate', '~> 3.0'
gem 'introjs-rails'
gem 'wicked'
#photo uploading
gem 'paperclip', '~> 3.4.1'
gem "cocaine", "~> 0.5.1"
gem 'aws-s3'
gem 'aws-sdk'
