require 'test_helper'
require 'discogs'

class DiscogsReleaseTest < ActiveSupport::TestCase
  context 'DiscogsRelease' do
    setup do
      @release = stub_everything(:title => 'Hit Record 2000')
      wrapper = stub_everything(:get_release => @release)
      Discogs::Wrapper.stubs(:new).with(anything).returns(wrapper)
      @item = items(:one)
      @item.update_attribute(:discogs_url, 'http://example.com')
      @discogs_release = DiscogsRelease.new(@item)
    end

    should 'pass methods through to the wrapper' do
      assert_equal @release.title, @discogs_release.title
    end
  end
end
