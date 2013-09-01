require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'

if defined?(Bundler)
  Bundler.require(:default, Rails.env)
end

module Rayons
  class Application < Rails::Application
    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    config.force_ssl = false

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '2.0'

    config.assets.initialize_on_precompile = false

    config.cache_store = :dalli_store
  end
end
