require "simplecov"
SimpleCov.start

ENV["RAILS_ENV"] ||= "test"
ENV["API_TOKEN_SIZE"] ||= "42"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.global_fixtures = :all
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.render_views
end
