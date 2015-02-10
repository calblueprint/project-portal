Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source 'https://rubygems.org'

ruby '2.1.1'
gem 'rails', '3.2.18'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development, :test do
  gem 'sqlite3', '~> 1.3.9'
  gem 'factory_girl_rails', '~>2.0'
  gem 'launchy', '~> 2.4.2'
  gem 'rspec-rails', '2.14.2'
  gem 'zeus', '~> 0.15.1'
  gem 'better_errors', '~> 1.1.0'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'annotate', '~> 2.6.1'
  gem 'awesome_print', '1.2.0', require: 'awesome_print'
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
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails', '~> 3.1.0'
gem 'twitter-bootstrap-rails', '~> 2.2.8'
gem 'best_in_place', '2.1.0'
#for adding comments to projects
gem 'acts_as_commentable_with_threading', '~> 1.2.0'
gem 'rails_autolink', '1.1.5'

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
gem 'bootstrap-sass', '~> 2.3.2.2'
gem 'haml', '~> 4.0.5'
gem 'devise'
gem 'simple_form', '~> 2.1.1'
gem 'carrierwave', '~> 0.10.0'
gem 'friendly_id', '~> 4.0.10.1'
gem 'populator', '~> 1.0.0'
gem 'ffaker', '~> 1.24.0'
gem 'will_paginate', '~> 3.0'
gem 'introjs-rails', '~> 0.5.0'
gem 'wicked', '~> 1.0.3'
gem 'newrelic_rpm'
#photo uploading
gem 'paperclip', '~> 3.4.1'
gem "cocaine", "~> 0.5.1"
gem 'aws-s3'
gem 'aws-sdk'
