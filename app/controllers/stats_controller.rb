class StatsController < ApplicationController
  before_filter :initialize_item_stats

  # GET /stats/counts_by_day.json
  def counts_by_day
    render json: (cache [:counts_by_day, Item.unscoped.maximum(:updated_at).to_i] do
      @item_stats.counts_by_day.to_json
    end)
  end

  # GET /stats
  def index
    render text: (cache [:stats, Item.unscoped.maximum(:updated_at).to_i] do
      @prices = @item_stats.significant_prices
      render_to_string
    end)
  end

  # GET /stats/time_machine
  def time_machine
    date = Time.local(Time.now.year, params[:month], params[:day]) if (params[:month] && params[:day])
    @time_machine = TimeMachine.new(date)
    respond_to do |format|
      format.json { render text: @time_machine.to_json }
      format.html do
        @mustache_template = render_to_string partial: '/items/template'
      end
    end
  end

  # GET /stats/words_for_field
  def words_for_field
    render json: (cache [:words_for_field, params[:field], Item.unscoped.maximum(:updated_at).to_i] do
      @item_stats.words_for_field(params[:field]).map{ |k,v| {text: k, weight: v} if v > 1 }.compact.to_json
    end)
  end

  private
  def initialize_item_stats
    @item_stats = ItemStats.new
  end

end
