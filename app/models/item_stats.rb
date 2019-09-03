require "memoist"

class ItemStats
  extend Memoist

  def counts_by_day
    times = Item.group_by_day(:created_at).count
    Hash[times.map { |k, v| [k.midnight.to_i, v] }]
  end

  def prices
    sql = Item.select(:price_paid).sorted("price_paid").to_sql
    Item.connection.select_values(sql).map { |p| p.delete("$").to_f }
  end

  def significant_prices
    {
      max_price: prices.last.round(2),
      min_price: prices.first.round(2),
      avg_price: prices.average.round(2),
      median_price: prices.median.round(2),
    }
  end

  def stats_for_field(field)
    stats = Item.select(field).group(field).order(field).count
    others = stats.select { |k,v| v <= 10 }.count
    stats.select { |k,v| v > 10 }.merge("Other" => others)
  end

  def top_10(field)
    case field.to_sym
    when :genres
      top_10_genres
    when :styles
      top_10_styles
    else
      Item.select(field).group(field).count.sort_by { |_, count| count }.last(10).reverse.to_h
    end
  end

  def price_stats
    Item.select(:price_paid).group(:price_paid).order("to_number(price_paid, '9999999.99')").count
  end

  def words_for_field(field)
    raise InvalidFieldError unless Item.column_names.include?(field.to_s)

    # Get a hash of the words in a field
    items = Item.select(field.to_sym).map { |i| i.send(field.to_sym).to_s.split(/[\s\/,\(\)]+/) }.flatten.group_by { |v| v }
    # return the frequency of each word
    Hash[items.map { |k, v| [k, v.count] }]
  end

  memoize :counts_by_day, :prices, :significant_prices, :stats_for_field, :price_stats, :words_for_field

  class InvalidFieldError < RuntimeError; end

  private

  # def top_10_genres and def top_10_styles
  # Use metaprogramming here to prevent sql injection if the field were a method parameter
  %w[genre style].each do |field|
    define_method :"top_10_#{field.pluralize}" do
      sql = <<-SQL
        WITH info as (
          select
            unnest(#{field.pluralize}) as #{field}
           from items
        ) select
          #{field}, count(*) as count
          from info
          group by #{field}
          order by count DESC;
      SQL
      ActiveRecord::Base.connection.exec_query(sql).rows.first(10).to_h
    end
  end
end
