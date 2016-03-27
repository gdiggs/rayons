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

    config.log_tags = [:uuid]

    config.active_record.schema_format = :sql

    config.assets.paths << Rails.root.join("vendor", "assets", "components")

    # via https://gist.github.com/afeld/5704079

    # We don't want the default of everything that isn't js or css, because it pulls too many things in
    config.assets.precompile.shift

    # Explicitly register the extensions we are interested in compiling
    config.assets.precompile.push(proc do |path|
      File.extname(path).in? [
        ".png", ".gif", ".jpg", ".jpeg", ".svg", # Images
        ".eot", ".otf", ".svc", ".woff", ".ttf", # Fonts
      ]
    end)
  end
end
