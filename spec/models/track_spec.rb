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
end
