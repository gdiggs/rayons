require 'test_helper'

class StatsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  context '#index' do
    should 'set title' do
      get :index
      assert_select 'title', "Rayons\n| Stats"
    end
  end

end
