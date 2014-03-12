require 'spec_helper'

describe ItemsController do
  render_views

  describe 'when logged in' do
    before do
      @item = items(:one)
      @user = users(:admin)
      sign_in @user
    end

    describe '#create' do
      it "should create item" do
        assert_difference('Item.count') do
          post :create, item: { artist: @item.artist, condition: @item.condition, format: @item.format, label: @item.label, price_paid: @item.price_paid, title: @item.title, year: @item.year }
        end

        assert_redirected_to item_path(assigns(:item))
      end
    end

    it "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:items)
    end

    it "should get new" do
      get :new
      assert_response :success
    end

    describe '#show' do
      describe 'with a discogs url' do
        before do
          @item.update_attribute(:discogs_url, 'http://example.com')
          release_stub = stub(:image_url => 'http://img',
                              :genres => ['Rock'],
                              :styles => ['Punk'],
                              :tracklist => [],
                              :notes => 'Best record ever'
                             )
          DiscogsRelease.expects(:new).with(@item).returns(release_stub)
          get :show, id: @item
          assert_response :success
        end

        it 'should render image' do
          assert_select "img[src=http://img]"
        end
      end
    end

    it "should get edit" do
      get :edit, id: @item
      assert_response :success
    end

    it "should update item" do
      put :update, id: @item, item: { artist: @item.artist, condition: @item.condition, format: @item.format, label: @item.label, price_paid: @item.price_paid, title: @item.title, year: @item.year }
      assert_redirected_to item_path(assigns(:item))
    end

    it "should destroy item" do
      assert_difference('Item.count', -1) do
        delete :destroy, id: @item
      end

      assert_redirected_to items_path
    end
  end

  describe '#index' do
    it 'should set flash error' do
      get :index, {}, nil, {:error => 'sup'}
      assert_select '.message.error', 'sup'
    end

    it 'should set flash notice' do
      get :index, {}, nil, {:notice => 'sup'}
      assert_select '.message', 'sup'
    end
  end

  describe 'when not logged in' do
    describe '#create' do
      it 'should return a 403' do
        post :create
        assert_response :forbidden
      end
    end
  end

end

