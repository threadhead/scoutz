source 'https://rubygems.org'

ruby '2.0.0'
gem 'rails', '3.2.13.rc2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
# gem 'pg'

gem 'thin'

gem 'devise'
# gem 'devise-async'
gem 'haml'
gem 'cancan'
gem 'state_machine'
gem 'carrierwave'
gem 'fog', '< 1.9.0'
gem 'mini_magick'
gem 'delayed_job_active_record'
gem 'carmen-rails'
gem 'wicked'
# gem 'slodown'
gem 'sanitize'
gem 'ckeditor'
# gem 'gmaps4rails'
gem 'public_activity'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'therubyracer'
  gem 'less-rails'

  gem 'twitter-bootstrap-rails'
  gem 'compass-rails'
end

gem 'jquery-rails' #fullCalendar is sensitive to the jQuery/jQuery UI version!
gem 'jquery-rails-cdn'

group :development, :test do
  # gem 'quiet_assets'
	gem 'haml-rails'
	gem 'rspec-rails'
	gem 'ffi'
	gem 'capybara'
	gem 'sextant'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'

  # gem 'meta_request'
  gem 'guard-livereload'
  gem 'rack-livereload'
  gem 'sextant'
  gem "letter_opener"
  gem 'wirble', require: false
  gem 'hirb', require: false
end


group :test do
	gem 'rake' # for travis-ci
	gem 'shoulda-matchers'
	gem 'factory_girl_rails'
	gem 'ffaker'
	gem 'spork-rails'
	gem 'rb-fsevent'
	gem 'terminal-notifier-guard'

	gem 'guard'
	gem 'guard-spork'
	gem 'guard-rspec'
  gem 'rspec-nc'

	gem 'database_cleaner'
	gem 'capybara-webkit'
  gem 'capybara-screenshot'

  gem 'simplecov', '>= 0.4.0', require: false
  gem 'simplecov-rcov', require: false
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
