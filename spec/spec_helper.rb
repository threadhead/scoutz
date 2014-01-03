require 'rubygems'
ENV["RAILS_ENV"] ||= 'test'

require 'simplecov'
# require 'simplecov-rcov'
# SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start 'rails'


# This file is copied to spec/ when you run 'rails generate rspec:install'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
# require 'rspec/autorun'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'shoulda/matchers/integrations/rspec'
# require 'webmock/rspec'

# load "#{Rails.root}/db/schema.rb"
# load_schema = lambda {
#     # use db agnostic schema by default
#     ActiveRecord::Schema.verbose = false
#     load "#{Rails.root.to_s}/db/schema.rb"

#     # if you use seeds uncomment next line
#     # load "#{Rails.root.to_s}/db/seeds.rb"
#     # ActiveRecord::Migrator.up('db/migrate') # use migrations
#   }
#   silence_stream(STDOUT, &load_schema)


# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  # config.extend ControllerMacros, :type => :controller
  # config.include ModelMacros, :type => :model
  config.include ModelHelpers, type: :model
  config.include FeatureHelpers, type: :feature

  # config.include RequestMacros
  # config.include ViewMacros, :type => :view
  config.include Gmaps4railsHelpers


  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.before(:each) do
    if Capybara.current_driver == :rack_test
      DatabaseCleaner.strategy = :transaction
    else
      DatabaseCleaner.strategy = :truncation
    end

    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:all) do
    # PublicActivity.enabled = false
    # ActiveRecord::Base.observers.disable(:all)

    User.delete_all
    Unit.delete_all
    SubUnit.delete_all
    Event.delete_all
    Phone.delete_all
    UserRelationship.delete_all
    EventSignup.delete_all
  end




  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false


  #some rspec configs
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run_including focus: true
  config.run_all_when_everything_filtered = true
end


VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.filter_sensitive_data('<SCOUTLANDER_PASSWORD>') { ENV['SCOUTLANDER_PASSWORD'] }
  c.default_cassette_options = { record: :new_episodes }
end
