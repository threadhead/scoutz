source 'https://rubygems.org'

ruby '2.1.1'
gem 'dotenv-rails'
gem 'dotenv-deployment'

gem 'rails', '4.1.1'

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
gem 'fog' #, '< 1.9.0'
gem 'mini_magick'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'carmen-rails'
gem 'mechanize'
gem 'wicked'
# gem 'slodown'
gem 'sanitize'
gem 'ckeditor'
# gem 'gmaps4rails'
gem 'public_activity' #, git: 'https://github.com/pokonski/public_activity.git', branch: 'rails4'
gem "non-stupid-digest-assets"
gem 'bootstrap_form'

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
  gem 'exception_notification'
end

# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails', '~> 4.0.3'
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
  gem 'whiny_validation'
  # gem 'quiet_assets'
	gem 'haml-rails'
	gem 'rspec-rails'
  # gem 'rspec-rails', '~> 3.0.0.beta2'
	gem 'ffi'
	gem 'capybara'
  gem 'awesome_print'

  gem 'vcr'
  gem 'webmock', '<= 1.16'

end

group :development do
  gem 'spring'
  gem "spring-commands-rspec"
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano' #, require: false
  gem 'capistrano-bundler' #, require: false
  gem 'capistrano-rails' #, require: false
  gem 'capistrano-rvm' #, require: false

  # gem 'meta_request'
  gem 'guard-livereload'
  gem 'rack-livereload'
  gem "letter_opener"
  gem 'wirble', require: false
  gem 'hirb', require: false
  gem 'brakeman', :require => false
end


group :test do
  # gem 'rspec-activemodel-mocks' #will need this when going to rspec 3.0
	# gem 'rake' # for travis-ci
  gem 'minitest'
  gem 'factory_girl_rails'
  gem 'ffaker'
  # gem 'spork-rails'
  gem 'rb-fsevent'
  gem 'terminal-notifier-guard'
  # gem 'vcr'
  # gem 'webmock', '<= 1.16'

  gem 'guard'
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

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0',          group: :doc

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
