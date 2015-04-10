source 'https://rubygems.org'

ruby '2.2.1'
gem 'dotenv-rails'

gem 'rails', '~> 4.2.1'

gem 'pg'
gem 'dalli'

# gem 'rake'

gem 'devise' #, git: 'https://github.com/plataformatec/devise.git', branch: 'lm-rails-4-2'
gem 'haml'
gem 'pundit'
gem 'state_machine'
gem 'carrierwave'
gem 'fog', require: 'fog/aws/storage'
gem 'mini_magick'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'mechanize'
gem 'wicked'
gem 'sanitize', '~> 2.1.0'
# gem 'gmaps4rails'
gem 'public_activity'
gem 'non-stupid-digest-assets'
gem 'bootstrap_form'
gem 'kaminari'
gem 'acts_as_list' #, git: 'https://github.com/swanandp/acts_as_list.git'
gem 'pg_search'

#gem 'twilio-ruby'
gem 'rest-client'
gem 'icalendar'
gem 'newrelic_rpm'

# gem 'vcr'
# gem 'webmock'


group :production, :staging do
  # gem 'newrelic_rpm'
  gem 'exception_notification'
end

# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails'
gem 'coffee-rails', '~> 4.1.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', :platform => :ruby

gem 'uglifier', '>= 1.3.0'
# gem 'therubyracer'
# gem 'less-rails'

gem 'bourbon'
gem 'jquery-rails'

#fullCalendar is sensitive to the jQuery/jQuery UI version!
# gem 'jquery-ui-rails'
gem 'whenever', require: false

group :development, :test do
    # Call 'debugger' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  # gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'spring-commands-rspec'
  gem 'whiny_validation'
  gem 'haml-rails'
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
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'airbrussh', require: false
  # gem 'capistrano-inspeqtor'

  gem 'guard'
  gem 'guard-rspec', '~> 4.2.9', require: false
  gem 'guard-livereload', require: false
  gem 'terminal-notifier-guard'

  # gem 'meta_request'
  gem 'rack-livereload'
  gem 'letter_opener'
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

