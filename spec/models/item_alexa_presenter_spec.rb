require "spec_helper"

describe ItemAlexaPresenter, type: :model do
  describe "#item" do
    it "should return a random item with the right intent" do
      params = {
        request: {
          intent: {
            name: "RandomItem",
          },
        },
      }
      presenter = ItemAlexaPresenter.new(params)

      expect(presenter.item).to be_a(Item)
    end

    it "should return a formatted record" do
      Item.create!(artist: "NOFX", price_paid: "$5.00", format: '12"')
      params = {
        request: {
          intent: {
            name: "FormattedItem",
            slots: {
              format: {
                name: "format",
                value: "12 inch",
              },
            },
          },
        },
      }
      presenter = ItemAlexaPresenter.new(params)

      expect(presenter.item).to be_a(Item)
      expect(presenter.item.format).to eq('12"')
    end

    it "should return nothing for an unknown intent" do
      presenter = ItemAlexaPresenter.new({})

      expect(presenter.item).to be_nil
    end
  end

  describe "#as_json" do
    it "should return an item with an intent" do
      Item.create!(artist: "NOFX", price_paid: "$5.00", format: '12"')
      params = {
        request: {
          intent: {
            name: "FormattedItem",
            slots: {
              format: {
                name: "format",
                value: "12 inch",
              },
            },
          },
        },
      }
      presenter = ItemAlexaPresenter.new(params)

      expect(presenter.as_json).to have_key(:response)
    end

    it "should return instructions with a launch request" do
      params = {
        request: {
          type: "LaunchRequest"
        }
      }
      presenter = ItemAlexaPresenter.new(params)
      result = presenter.as_json[:response][:outputSpeech][:text]

      expect(result).to include("Welcome to The Record Collection")
    end
  end
end
