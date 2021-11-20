require "spec_helper"

module Api
  describe ItemsController, type: :controller do
    before do
      @user = users(:admin)
      @token = ApiToken.create(name: "test", user: @user)
    end

    describe "#show" do
      it "gets an item" do
        item = items(:one)

        request.headers["Authorization"] = "Token #{@token.token}"
        get :show, params: { id: item }
        expect(response).to be_successful
      end
    end
  end
end
