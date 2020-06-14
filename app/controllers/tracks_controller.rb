class TracksController < ApplicationController
  def index
    @track_finder = TrackFinder.new(track_finder_params)
    @names = [nil] + Track.order(:name).distinct.pluck(:name)
    @artists = [nil] + Track.order(:artist).distinct.pluck(:artist)
  end

  private

  def track_finder_params
    params.permit(:name, :artist)
  end
end
