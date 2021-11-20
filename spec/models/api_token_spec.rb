require "spec_helper"

describe ApiToken do
  before do
    @user = users(:admin)
  end

  describe "validations" do
    it "validates that the name is present" do
      token = ApiToken.new
      token.validate

      expect(token.errors[:name]).to include("can't be blank")
    end

    it "validates that the user is present" do
      token = ApiToken.new
      token.validate

      expect(token.errors[:user_id]).to include("can't be blank")
    end

    it "generates a token automatically" do
      token = ApiToken.create(user: @user, name: "Gibson")

      expect(token.token).to be_present
    end

    it "does not allow modifying a token" do
      token = ApiToken.create(user: @user, name: "Gibson")
      mytoken = "lovesexsecretgod"

      expect do
        token.token = mytoken
        token.save
      end.not_to change { token.reload.token }
    end

    it "does not allow passing a custom token" do
      mytoken = "lovesexsecretgod"
      token = ApiToken.create(user: @user, name: "ThePlague", token: mytoken)

      expect(token.token).not_to eq(mytoken)
    end
  end
end
