require 'spec_helper'

class TestController < ApplicationController
  def index
    head 200
  end
end

describe ApplicationController, :type => :controller do
  before do
    Rayons::Application.routes.append do
      get 'test_application' => "test#index"
    end

    Rayons::Application.reload_routes!

    @controller = TestController.new
  end

  describe '#check_responsive' do
    it 'should set the cookie' do
      get :index, :exclude_responsive => true
      assert_equal true, cookies[:exclude_responsive]
    end

    it 'should delete the cookie' do
      get :index, :exclude_responsive => 'false'
      assert_nil cookies[:exclude_responsive]
    end
  end
end
