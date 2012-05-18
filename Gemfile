source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
gem 'pg'

gem 'thin'

gem 'devise'
# gem 'devise-async'
gem 'haml'
gem 'cancan'
gem 'state_machine'
gem 'carrierwave'
gem 'fog'
gem 'mini_magick'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails'
  gem 'compass-rails'
end

gem 'jquery-rails'

group :development, :test do
	gem 'haml-rails'
	gem 'rspec-rails'
	gem 'ffi'
	gem 'capybara'

	# this ensures gems used in development are installed, comment out if you don't want them
  gem 'powder', :require => false
  gem 'hirb', :require => false
  gem 'wirble', :require => false
  gem 'heroku', :require => false
  gem 'foreman', :require => false
end

group :test do
	gem 'rake' # for travis-ci
	gem 'shoulda-matchers'
	gem 'factory_girl_rails'
	gem 'ffaker'
	gem 'spork-rails'
	gem 'rb-fsevent'
	gem 'growl'

	gem 'guard'
	gem 'guard-spork'
	gem 'guard-rspec'

	gem 'database_cleaner'
	gem 'capybara-webkit'
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
