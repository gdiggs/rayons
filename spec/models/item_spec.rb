require "spec_helper"

describe Item, type: :model do
  describe "validation" do
    it "should not allow invalid urls" do
      item = Item.new(discogs_url: "supsupsup")
      assert !item.valid?
      assert item.errors.include?(:discogs_url)
    end

    it "should allow blank urls" do
      item = Item.new
      item.valid?
      assert !item.errors.include?(:discogs_url)
    end

    it "should allow valid urls" do
      item = Item.new(discogs_url: "http://www.discogs.com/NOFX-The-Decline/release/3916848")
      item.valid?
      assert !item.errors.include?(:discogs_url)
    end
  end

  describe ".search" do
    it "should search year with an integer" do
      item = Item.create!(year: 1989, price_paid: "$5.00")
      assert Item.search("1989").include?(item)
    end

    it "should search with a search query" do
      item = Item.create!(artist: "NOFX", price_paid: "$5.00")
      assert Item.search("NOFX").include?(item)
    end
  end
end
