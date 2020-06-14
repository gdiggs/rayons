class TrackFinder
  def initialize(attributes = {})
    @name = attributes[:name]
    @artist = attributes[:artist]
  end

  def tracks
    tracks = Track.includes(:item).order(:artist, :name)
    tracks = tracks.basic_search(name: name) if name.present?
    tracks = tracks.where(artist: artist) if artist.present?

    tracks
  end

  def count
    tracks.count(:id)
  end

  private

  attr_reader :name, :artist
end
