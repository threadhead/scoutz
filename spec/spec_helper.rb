require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'
ENV["RAILS_ENV"] ||= 'test'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  # require 'rspec/autorun'
  require 'capybara/rails'
  require 'capybara/rspec'
  require 'capybara-screenshot/rspec'
  require 'shoulda/matchers/integrations/rspec'

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
      ActiveRecord::Base.observers.disable(:all)

      User.delete_all
      Organization.delete_all
      SubUnit.delete_all
      Event.delete_all
      Phone.delete_all
      UserRelationship.delete_all
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
end



Spork.each_run do
  # This code will be run each time you run your specs.
  load_schema = lambda {
      ActiveRecord::Schema.verbose = false
      # use db agnostic schema by default
      load "#{Rails.root.to_s}/db/schema.rb"

      # if you use seeds uncomment next line
      # load "#{Rails.root.to_s}/db/seeds.rb"
      # ActiveRecord::Migrator.up('db/migrate') # use migrations
    }
    silence_stream(STDOUT, &load_schema)

  FactoryGirl.reload

  # FactoryGirl.definition_file_paths = [File.join(Rails.root, 'spec', 'factories')]
  # FactoryGirl.find_definitions

  # temp fix for rspec run times
  # $rspec_start_time = Time.now

end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.
