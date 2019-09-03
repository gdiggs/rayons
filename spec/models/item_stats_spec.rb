require "spec_helper"

describe ItemStats, type: :model do
  describe "#top_10" do
    it "returns the top 10 genres" do
      Item.create!(year: 1989, price_paid: "$5.00", genres: ["Rock"], styles: ["Punk"])
      Item.create!(year: 1989, price_paid: "$5.00", genres: ["Rock"], styles: ["Punk"])
      Item.create!(year: 1989, price_paid: "$5.00", genres: ["Rock"], styles: ["Hardcore"])
      Item.create!(year: 1989, price_paid: "$5.00", genres: ["Jazz"], styles: ["Free Jazz"])

      result = {
        "Rock" => 3,
        "Jazz" => 1,
      }

      expect(ItemStats.new.top_10("genres")).to eq result
    end

    it "returns the top 10 styles" do
      Item.create!(year: 1989, price_paid: "$5.00", genres: ["Rock"], styles: ["Punk"])
      Item.create!(year: 1989, price_paid: "$5.00", genres: ["Rock"], styles: ["Punk"])
      Item.create!(year: 1989, price_paid: "$5.00", genres: ["Rock"], styles: ["Hardcore"])
      Item.create!(year: 1989, price_paid: "$5.00", genres: ["Jazz"], styles: ["Free Jazz"])

      result = {
        "Punk" => 2,
        "Hardcore" => 1,
        "Free Jazz" => 1,
      }

      expect(ItemStats.new.top_10("styles")).to eq result
    end
  end
end
