require "spec_helper"

describe ItemsController, type: :controller do
  render_views

  describe "when logged in" do
    before do
      @item = items(:one)
      @user = users(:admin)
      sign_in @user
    end

    describe "#create" do
      it "should create item" do
        original_item_count = Item.count
        post :create,
             params: { item: { artist: @item.artist, condition: @item.condition, format: @item.format, label: @item.label, price_paid: @item.price_paid, title: @item.title, year: @item.year } }

        expect(Item.count).to eq original_item_count + 1
        expect(subject).to redirect_to item_path(assigns(:item))
      end
    end

    it "should get index" do
      get :index
      expect(response).to be_success
    end

    it "should get edit" do
      get :edit, params: { id: @item }
      expect(response).to be_success
    end

    it "should update item" do
      put :update,
          params: {
            id: @item,
            item: { artist: @item.artist, condition: @item.condition, format: @item.format, label: @item.label, price_paid: @item.price_paid, title: @item.title, year: @item.year },
          }
      expect(subject).to redirect_to item_path(assigns(:item))
    end

    it "should destroy item" do
      original_item_count = Item.count
      delete :destroy, params: { id: @item }

      expect(Item.count).to eq original_item_count - 1
      expect(subject).to redirect_to items_path
    end
  end

  describe "#daily" do
    it "should return the right format" do
      get :daily

      expect(response).to be_success
    end
  end

  describe "when not logged in" do
    describe "#create" do
      it "should return a 403" do
        post :create
        expect(response).to be_forbidden
      end
    end
  end
end
