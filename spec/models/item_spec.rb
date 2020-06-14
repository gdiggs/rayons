require "spec_helper"

describe Item, type: :model do
  describe "validation" do
    it "should not allow invalid urls" do
      item = Item.new(discogs_url: "supsupsup")
      expect(item).not_to be_valid
      expect(item.errors).to include :discogs_url
    end

    it "should allow blank urls" do
      item = Item.new
      item.valid?
      expect(item.errors).not_to include :discogs_url
    end

    it "should allow valid urls" do
      item = Item.new(discogs_url: "http://www.discogs.com/NOFX-The-Decline/release/3916848")
      item.valid?
      expect(item.errors).not_to include :discogs_url
    end
  end

  describe ".search" do
    it "should search year with an integer" do
      item = Item.create!(year: 1989, price_paid: "$5.00")
      expect(Item.search("1989")).to include(item)
    end

    it "should search with a search query" do
      item = Item.create!(artist: "NOFX", price_paid: "$5.00")
      expect(Item.search("NOFX")).to include(item)
    end
  end

  describe "#destroy" do
    it "should also destroy any tracks" do
      item = Item.create!(artist: "NOFX", price_paid: "$5.00")
      track = item.tracks.create(artist: "NOFX", name: "Hello")

      item.destroy
      expect(Track.find_by_id(track.id)).to be_nil
    end
  end
end
