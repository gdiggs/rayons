require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  context 'validation' do
    should 'not allow invalid urls' do
      item = Item.new(:discogs_url => 'supsupsup')
      assert !item.valid?
      assert item.errors.include?(:discogs_url)
    end

    should 'allow blank urls' do
      item = Item.new
      item.valid?
      assert !item.errors.include?(:discogs_url)
    end

    should 'allow valid urls' do
      item = Item.new(:discogs_url => 'http://www.discogs.com/NOFX-The-Decline/release/3916848')
      item.valid?
      assert !item.errors.include?(:discogs_url)
    end
  end
end
