source 'https://rubygems.org'

ruby '2.1.4'
gem 'dotenv-rails'
gem 'dotenv-deployment'

gem 'rails', '4.1.7'
gem 'pg'

gem 'devise'
# gem 'devise-async'
gem 'haml'
gem 'pundit'
gem 'state_machine'
gem 'carrierwave'
gem 'fog', require: "fog/aws/storage"
gem 'mini_magick'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'carmen-rails'
gem 'mechanize'
gem 'wicked'
# gem 'slodown'
gem 'sanitize', '~> 2.1.0'
# gem 'ckeditor'
# gem 'gmaps4rails'
gem 'public_activity'
gem "non-stupid-digest-assets"
gem 'bootstrap_form'
gem 'kaminari'
gem 'acts_as_list'
gem 'pg_search'
# gem 'textacular', require: 'textacular/searchable'


#gem 'twilio-ruby'
gem 'rest-client'
gem 'icalendar'
gem 'newrelic_rpm'

# gem 'vcr'
# gem 'webmock'


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
# gem 'jquery-ui-rails'
gem 'whenever', :require => false

group :development, :test do
  gem 'whiny_validation'
  gem 'haml-rails'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rspec-activemodel-mocks'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'awesome_print'

  gem 'vcr'
  gem 'webmock'

end

group :development do
  gem 'quiet_assets'
  gem 'spring'
  gem "spring-commands-rspec"
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'

  gem 'guard'
  gem 'guard-rspec', '~> 4.2.9', require: false
  gem 'guard-livereload', require: false
  gem 'terminal-notifier-guard'

  # gem 'meta_request'
  gem 'rack-livereload'
  gem "letter_opener"
  gem 'wirble', require: false
  gem 'hirb', require: false
  gem 'brakeman', require: false
end


group :test do
  gem 'sqlite3'
	gem 'shoulda-matchers', require: false
	gem 'database_cleaner'
	gem 'capybara-webkit'
  gem 'capybara-screenshot'

  gem 'simplecov', require: false
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
