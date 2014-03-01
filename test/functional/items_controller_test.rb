require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  context 'when logged in' do
    setup do
      @item = items(:one)
      @user = users(:admin)
      sign_in @user
    end

    context '#create' do
      should "create item" do
        assert_difference('Item.count') do
          post :create, item: { artist: @item.artist, condition: @item.condition, format: @item.format, label: @item.label, price_paid: @item.price_paid, title: @item.title, year: @item.year }
        end

        assert_redirected_to item_path(assigns(:item))
      end
    end

    should "get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:items)
    end

    should "get new" do
      get :new
      assert_response :success
    end

    should "show item" do
      get :show, id: @item
      assert_response :success
    end

    should "get edit" do
      get :edit, id: @item
      assert_response :success
    end

    should "update item" do
      put :update, id: @item, item: { artist: @item.artist, condition: @item.condition, format: @item.format, label: @item.label, price_paid: @item.price_paid, title: @item.title, year: @item.year }
      assert_redirected_to item_path(assigns(:item))
    end

    should "destroy item" do
      assert_difference('Item.count', -1) do
        delete :destroy, id: @item
      end

      assert_redirected_to items_path
    end
  end

  context '#index' do
    should 'set flash error' do
      get :index, {}, nil, {:error => 'sup'}
      assert_select '.message.error', 'sup'
    end

    should 'set flash notice' do
      get :index, {}, nil, {:notice => 'sup'}
      assert_select '.message', 'sup'
    end
  end

  context 'when not logged in' do
    context '#create' do
      should 'return a 403' do
        post :create
        assert_response :forbidden
      end
    end
  end

end
