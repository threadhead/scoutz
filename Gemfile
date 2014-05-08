source 'https://rubygems.org'

ruby '2.1.1'
gem 'dotenv-deployment'
gem 'rails', '4.0.5'

gem 'sqlite3'
# gem 'pg'

# gem 'thin'
# gem 'rake'

gem 'devise'
# gem 'devise-async'
gem 'haml'
gem 'cancan'
gem 'state_machine'
gem 'carrierwave'
gem 'fog', '< 1.9.0'
gem 'mini_magick'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'carmen-rails'
gem 'wicked'
# gem 'slodown'
gem 'sanitize'
gem 'ckeditor'
# gem 'gmaps4rails'
gem 'public_activity' #, git: 'https://github.com/pokonski/public_activity.git', branch: 'rails4'
gem "non-stupid-digest-assets"

# add these gems to help with the transition:
# gem 'protected_attributes'
# gem 'rails-observers'
# gem 'actionpack-page_caching'
# gem 'actionpack-action_caching'

gem 'twilio-ruby'
gem 'icalendar'

group :production, :staging do
  # gem 'newrelic_rpm'
  gem 'dalli'  # memcache client
end


# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails', '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', :platform => :ruby

gem 'uglifier', '>= 1.3.0'
# gem 'therubyracer'
# gem 'less-rails'

gem 'bourbon'
gem 'jquery-rails'

#fullCalendar is sensitive to the jQuery/jQuery UI version!
gem 'jquery-ui-rails'
# gem 'jquery-rails-cdn'

group :development, :test do
  # gem 'quiet_assets'
	gem 'haml-rails'
	gem 'rspec-rails'
  # gem 'rspec-rails', '~> 3.0.0.beta2'
	gem 'ffi'
	gem 'capybara'
  gem 'awesome_print'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano', require: false
  gem 'capistrano_colors', require: false
  gem 'rvm-capistrano', require: false

  # gem 'meta_request'
  gem 'guard-livereload'
  gem 'rack-livereload'
  gem "letter_opener"
  gem 'wirble', require: false
  gem 'hirb', require: false
  gem 'brakeman', :require => false
end


group :test do
	gem 'rake' # for travis-ci
  gem 'minitest'
  gem 'factory_girl_rails'
  gem 'ffaker'
  # gem 'spork-rails'
  gem 'rb-fsevent'
  gem 'terminal-notifier-guard'

  gem 'guard'
  gem 'guard-zeus'
  gem 'guard-rspec'
	gem 'shoulda-matchers'

	gem 'database_cleaner' #, git: 'https://github.com/bmabey/database_cleaner', branch: 'master'
	gem 'capybara-webkit'
  gem 'capybara-screenshot'

  gem 'simplecov', require: false
  # gem 'simplecov-rcov', require: false
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
