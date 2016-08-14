require "spec_helper"
require "discogs"

describe DiscogsRelease, type: :model do
  before do
    @release = stub_everything(title: "Hit Record 2000", notes: "Probably the best")
    wrapper = stub_everything(get_release: @release)
    Discogs::Wrapper.stubs(:new).returns(wrapper)
    @item = items(:one)
    @item.update_attribute(:discogs_url, "http://example.com")
    @discogs_release = DiscogsRelease.new(@item)
  end

  it "should pass methods through to the wrapper" do
    assert_equal @release.title, @discogs_release.title
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
