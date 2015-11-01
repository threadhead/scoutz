# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require 'simplecov'
SimpleCov.start 'rails'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
RSpec.configure { |c| c.deprecation_stream = File.join(Rails.root, 'log', 'rspec_deprecations.log') }

require 'shoulda/matchers'
require 'capybara/rails'
require 'capybara/rspec'
# require 'capybara-screenshot'
require 'capybara-screenshot/rspec'
require 'pundit/rspec'

Capybara::Screenshot.prune_strategy = { keep: 20 }

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end


RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.mock_with :rspec do |mocks|
    mocks.syntax = [:should, :expect]
  end


  config.include Devise::TestHelpers, type: :controller
  # config.extend ControllerMacros, :type => :controller
  # config.include ModelMacros, :type => :model
  config.include ModelHelpers, type: :model
  config.include FeatureHelpers, type: :feature
  config.include PolicyHelpers, type: :policy

  # config.include RequestMacros
  # config.include ViewMacros, :type => :view
  config.include Gmaps4railsHelpers


  config.filter_run_including focus: true
  config.run_all_when_everything_filtered = true
  # TODO: turn this on eventually
  config.expose_dsl_globally = false



  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true
  config.use_transactional_fixtures = false

  config.before(:each) do
    # DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.strategy = Capybara.current_driver == :rack_test ? :transaction : :truncation
    DatabaseCleaner.start
    # This should effectively stop all creating ical files, which will happen in an after_save callback
    # on Event. To remove this stub, call: reset(Event)
    Event.class_variable_set(:@@disable_ical_generation, true)
    # allow_any_instance_of(Event).to receive(:ical_valid?).and_return(false)
    Google::UrlShortenerV1::Base.stub(:shorten).and_return("http://goo.gl/vZewJH")
  end

  config.before(:each, js: true) do
    # DatabaseCleaner.strategy = :truncation
    page.driver.browser.url_blacklist = ["//cdnjs.cloudflare.com/ajax/libs/font-awesome", "//fonts.googleapis.com/", "//www.google-analytics.com"]
  end


  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:all) do
    DatabaseCleaner.clean_with(:truncation)
    PublicActivity.enabled = false

    # User.delete_all
    # Unit.delete_all
    # SubUnit.delete_all
    # Event.delete_all
    # Phone.delete_all
    # UserRelationship.delete_all
    # EventSignup.delete_all
    # Page.delete_all
    # MeritBadge.delete_all
  end

  config.after(:all) do
    if Rails.env.test?
      FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
    end
  end


  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explictly tag your specs with their type, e.g.:
  #
  #     describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/v/3-0/docs
  config.infer_spec_type_from_file_location!

  Capybara::Screenshot.webkit_options = { width: 1200, height: 768 }
  Capybara::Screenshot.prune_strategy = { keep: 20 }
end



if defined?(CarrierWave)
  CarrierWave::Uploader::Base.descendants.each do |klass|
    next if klass.anonymous?
    klass.class_eval do
      def cache_dir
        "#{Rails.root}/spec/support/uploads/tmp"
      end
    end
  end
end
