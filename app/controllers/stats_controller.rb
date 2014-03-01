class StatsController < ApplicationController
  caches_page :stats, :counts_by_day
  caches_action :words_for_field, :cache_path => Proc.new { |c| "words_for_field_#{c.params[:field]}_#{Item.unscoped.maximum(:updated_at).to_i}" }

  # GET /stats/counts_by_day.json
  def counts_by_day
    render json: Item.counts_by_day
  end

  # GET /stats
  def index
    @prices = Item.significant_prices
  end

  # GET /stats/time_machine
  def time_machine
    @month_ago = Item.sorted.added_on_day 1.month.ago
    @six_months_ago = Item.sorted.added_on_day 6.months.ago
    @year_ago = Item.sorted.added_on_day 1.year.ago
  end

  # GET /stats/words_for_field
  def words_for_field
    render json: Item.words_for_field(params[:field]).map{ |k,v| {text: k, weight: v} if v > 1 }.compact
  end

end
