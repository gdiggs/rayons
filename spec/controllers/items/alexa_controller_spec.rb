require "spec_helper"

describe Items::AlexaController, type: :controller do
  describe "#random" do
    it "should return a 400 if the request is not verifyable" do
      post :random
      expect(response).to have_http_status(400)
    end

    it "should post random" do
      expect(AlexaVerifier).to receive(:valid?).and_return(true)

      post :random
      expect(response).to be_successful
    end
  end
end
