require File.expand_path("../boot", __FILE__)

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Rayons
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    config.i18n.enforce_available_locales = true

    config.autoload_paths += Dir["#{config.root}/app/policies/**"]
    config.autoload_paths += Dir["#{config.root}/app/controllers/api/**"]

    config.log_tags = [:uuid]

    config.assets.paths << Rails.root.join("vendor", "assets", "components")

    config.action_dispatch.rescue_responses.merge!(
      "DiscogsWrapper::ReleaseNotFoundError" => :not_found,
    )
  end
end
