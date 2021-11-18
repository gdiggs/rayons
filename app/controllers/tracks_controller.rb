class TracksController < ApplicationController

  before_action :authenticate_user!
  include Pagy::Backend

  def index
    @track_finder = TrackFinder.new(track_finder_params)
    @artists = [nil] + Track.order(:artist).distinct.pluck(:artist)
    @pagy, @tracks = pagy(@track_finder.tracks)
  end

  def show
    @track = Track.find(params[:id])
  end

  private

  def track_finder_params
    params.permit(:name, :artist)
  end
end
