require 'test_helper'

class TestController < ApplicationController
  def index
    head 200
  end
end

class ApplicationControllerTest < ActionController::TestCase

  setup do
    Rayons::Application.routes.append do
      get 'test_application' => "test#index"
    end

    Rayons::Application.reload_routes!

    @controller = TestController.new
  end

  context '#check_responsive' do
    should 'set the cookie' do
      get :index, :exclude_responsive => true
      assert_equal true, cookies[:exclude_responsive]
    end

    should 'delete the cookie' do
      get :index, :exclude_responsive => 'false'
      assert_nil cookies[:exclude_responsive]
    end
  end
end
