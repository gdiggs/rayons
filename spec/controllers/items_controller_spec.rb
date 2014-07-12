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
        original_item_count = Item.count
        post :create, item: { artist: @item.artist, condition: @item.condition, format: @item.format, label: @item.label, price_paid: @item.price_paid, title: @item.title, year: @item.year }

        assert_equal original_item_count+1, Item.count
        assert_redirected_to item_path(assigns(:item))
      end
    end

    it "should get index" do
      get :index
      assert_response :success
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
                              :notes => 'Best record ever',
                              :extra_info? => true
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
      original_item_count = Item.count
      delete :destroy, id: @item

      assert_equal original_item_count-1, Item.count
      assert_redirected_to items_path
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

