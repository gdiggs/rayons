require "spec_helper"

describe ItemImporter, type: :model do
  it "returns an item" do
    item = Item.create!(artist: "NOFX", price_paid: "$5.00")
    urls = %w[https://www.discogs.com/NOFX-The-Decline/release/3916848]

    expect_any_instance_of(DiscogsImporter).to receive(:import).and_return(item)

    items, errors = ItemImporter.new(urls).import

    expect(items.count).to eq(1)
    expect(items.first).to eq(item)
    expect(errors).to be_empty
  end

  it "returns an error" do
    urls = %w[https://www.discogs.com/NOFX-The-Decline/release/3916848]
    expect_any_instance_of(DiscogsImporter).to receive(:import).and_raise(StandardError)

    items, errors = ItemImporter.new(urls).import

    expect(items.count).to eq(0)
    expect(errors).not_to be_empty
  end
end
