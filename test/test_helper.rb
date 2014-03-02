require 'coveralls'
Coveralls.wear!('rails')

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'

Turn.config do |c|
 c.format  = :pretty
 c.trace   = false
end

class ActiveSupport::TestCase
  fixtures :all
end
