require "spec_helper"
require "discogs"

describe DiscogsRelease, type: :model do
  before do
    @release = double(title: "Hit Record 2000", notes: "Probably the best")
    wrapper = double(get_release: @release)
    expect(Discogs::Wrapper).to receive(:new).and_return(wrapper)
    @item = items(:one)
    @item.update_attribute(:discogs_url, "http://example.com")
    @discogs_release = DiscogsRelease.new(@item)
  end

  it "should pass methods through to the wrapper" do
    expect(@discogs_release.title).to eq @release.title
  end

  describe "#notes" do
    before do
      @item.update_attribute(:notes, "OK")
    end

    it "should combine the item notes and the release notes" do
      expect(@discogs_release.notes).to eq("OK\nProbably the best")
    end
  end
end
