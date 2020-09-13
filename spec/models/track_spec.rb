require "spec_helper"

describe Track, type: :model do
  describe "validation" do
    it "should have an artist" do
      track = Track.new

      expect(track).not_to be_valid
      expect(track.errors).to include :artist
    end

    it "should have an item" do
      track = Track.new

      expect(track).not_to be_valid
      expect(track.errors).to include :item_id
    end

    it "should have a name" do
      track = Track.new

      expect(track).not_to be_valid
      expect(track.errors).to include :name
    end
  end

  describe "#destroy" do
    it "should soft delete" do
      track = Track.create!(name: "Sup", artist: "Cool Folk", item: Item.last)

      track.destroy

      expect(track).to be_deleted
      expect(Track.unscoped.find(track.id)).to be_present
    end
  end

  describe "#possible_covers" do
    it "should find a cover" do
      original = Track.create!(name: "Sup", artist: "OG", item: Item.last)
      cover = Track.create!(name: "Sup", artist: "The Best Cover Band", item: Item.last)

      expect(original.possible_covers.count).to eq(1)
      expect(original.possible_covers).to include(cover)
    end
  end

  describe "#possible_alternates" do
    it "should find an alternate" do
      original = Track.create!(name: "Sup", artist: "OG", item: Item.last)
      alternate = Track.create!(name: "Sup", artist: "OG", item: Item.first)

      expect(original.possible_alternates.count).to eq(1)
      expect(original.possible_alternates).to include(alternate)
    end

    it "should not include itself" do
      original = Track.create!(name: "Sup", artist: "OG", item: Item.last)
      _cover = Track.create!(name: "Sup", artist: "The Best Cover Band", item: Item.last)

      expect(original.possible_alternates).not_to include(original)
    end
  end
end
