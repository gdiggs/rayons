ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

Turn.config do |c|
 c.format  = :pretty
 c.trace   = false
end

class ActiveSupport::TestCase
  fixtures :all
end
