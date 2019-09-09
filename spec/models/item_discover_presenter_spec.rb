require "spec_helper"

describe ItemDiscoverPresenter do
  describe "#item" do
    it "queries by a string field" do
      Item.create!(artist: "NOFX", price_paid: "$0.00")

      expect(ItemDiscoverPresenter.new(artist: "NOFX").item).to be_present
    end

    it "queries by multiple fields" do
      Item.create!(artist: "NOFX", genres: %w[Rock], price_paid: "$0.00")

      expect(ItemDiscoverPresenter.new(artist: "NOFX", genre: "Rock").item).to be_present
    end

    it "returns no results if the query is blank" do
      expect(ItemDiscoverPresenter.new.item).to be_nil
    end

    it "queries by genre" do
      Item.create!(genres: %w[Rock], price_paid: "$0.00")

      expect(ItemDiscoverPresenter.new(genre: "Rock").item).to be_present
    end

    it "queries by style" do
      Item.create!(styles: %w[Punk Hardcore], price_paid: "$0.00")

      expect(ItemDiscoverPresenter.new(style: "Punk").item).to be_present
    end

    it "handles characters properly" do
      Item.create!(styles: %w[Children's Hardcore], price_paid: "$0.00")

      expect(ItemDiscoverPresenter.new(style: "Children's").item).to be_present
    end
  end
end
