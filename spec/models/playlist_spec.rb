require 'spec_helper'

describe Playlist, :type => :model do
  describe 'validation' do
    it 'should not allow blank names' do
      playlist = Playlist.new
      playlist.valid?
      assert playlist.errors.include?(:name)
    end
  end
end

