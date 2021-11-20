class StatsController < ApplicationController
  before_action :authenticate_user!
  before_action :initialize_item_stats, except: :time_machine
  before_action :initialize_time_machine, only: :time_machine

  # GET /stats/counts_by_day.json
  def counts_by_day
    render json: (cache [:counts_by_day, Item.unscoped.maximum(:updated_at).to_i] do
      @item_stats.counts_by_day.to_json
    end)
  end

  # GET /stats
  def index
    render html: (cache [:item_stats, Item.unscoped.maximum(:updated_at).to_i, Rails.configuration.git_revision] do
      @prices = @item_stats.significant_prices
      render_to_string
    end)
  end

  # GET /stats/time_machine
  def time_machine; end

  # GET /stats/words_for_field
  def words_for_field
    render json: (cache [:words_for_field, params[:field], Item.unscoped.maximum(:updated_at).to_i] do
      @item_stats.words_for_field(params[:field]).map { |k, v| { text: k, weight: v } if v > 1 }.compact.to_json
    end)
  end

  private

  def initialize_item_stats
    @item_stats = ItemStats.new
  end

  def initialize_time_machine
    if params[:month] && params[:day]
      date = Time.local(Time.now.year, params[:month], params[:day])
      @time_machine = TimeMachine.new(date)
    else
      @time_machine = TimeMachine.new
    end
  end
end
