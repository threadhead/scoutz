require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Scoutz
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    config.i18n.enforce_available_locales = false
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de


    # FROM RAILS 3 -- NOT NEEDED?
    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib #{config.root}/models/concerns)
    # config.autoload_paths += %W(#{config.root}/app/models/ckeditor)

    # config.assets.precompile += ['jquery.js']


    # Override layout for devise controllers
    config.to_prepare do
      Devise::SessionsController.layout 'dialog_dark_modal'
      Devise::RegistrationsController.layout 'dialog_dark_modal'
      Devise::ConfirmationsController.layout 'dialog_dark_modal'
      Devise::UnlocksController.layout 'dialog_dark_modal'
      Devise::PasswordsController.layout 'dialog_dark_modal'
      # Devise::Mailer.layout "email" # email.haml or email.erb
    end

  end
end

APP_NAME = ::Rails.env.production? ? 'SCOUTTin' : "Scoutz - #{::Rails.env}"
