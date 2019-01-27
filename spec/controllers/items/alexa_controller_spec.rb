require "spec_helper"

describe Items::AlexaController, type: :controller do
  describe "#random" do
    it "should post random" do
      post :random
      expect(response).to be_success
    end
  end
end
