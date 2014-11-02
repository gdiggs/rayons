class StatsController < ApplicationController
  # GET /stats/counts_by_day.json
  def counts_by_day
    render json: (cache [:counts_by_day, Item.unscoped.maximum(:updated_at).to_i] do
      Item.counts_by_day.to_json
    end)
  end

  # GET /stats
  def index
    render text: (cache [:stats, Item.unscoped.maximum(:updated_at).to_i] do
      @prices = Item.significant_prices
      render_to_string
    end)
  end

  # GET /stats/time_machine
  def time_machine
    @month_ago = Item.sorted.added_on_day 1.month.ago
    @six_months_ago = Item.sorted.added_on_day 6.months.ago
    @year_ago = Item.sorted.added_on_day 1.year.ago
  end

  # GET /stats/words_for_field
  def words_for_field
    render json: (cache [:words_for_field, params[:field], Item.unscoped.maximum(:updated_at).to_i] do
      Item.words_for_field(params[:field]).map{ |k,v| {text: k, weight: v} if v > 1 }.compact.to_json
    end)
  end

end
