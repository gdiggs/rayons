require "spec_helper"

describe TrackFinder do
  it "finds tracks by name" do
    item = Item.create!(artist: "NOFX", price_paid: "$0.00")
    track = item.tracks.create!(name: "The Longest Line", artist: "NOFX")
    item.tracks.create!(name: "Linoleum", artist: "NOFX")

    finder = TrackFinder.new(name: "The Longest Line")

    expect(finder.count).to eq(1)
    expect(finder.tracks).to include(track)
  end

  it "finds tracks by artist" do
    item = Item.create!(artist: "NOFX", price_paid: "$0.00")
    track = item.tracks.create!(name: "The Longest Line", artist: "NOFX")
    item.tracks.create!(name: "Linoleum", artist: "Frank Turner")

    finder = TrackFinder.new(artist: "NOFX")

    expect(finder.count).to eq(1)
    expect(finder.tracks).to include(track)
  end

  it "finds tracks by name and artist" do
    item = Item.create!(artist: "NOFX", price_paid: "$0.00")
    track = item.tracks.create!(name: "Linoleum", artist: "NOFX")
    item.tracks.create!(name: "Linoleum", artist: "Frank Turner")

    finder = TrackFinder.new(artist: "NOFX", name: "Linoleum")

    expect(finder.count).to eq(1)
    expect(finder.tracks).to include(track)
  end
end
