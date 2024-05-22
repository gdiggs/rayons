module ItemsHelper
  def discogs_percent
    number_with_url = Item.where("discogs_url IS NOT NULL").count
    "#{number_with_delimiter(number_with_url)} / #{number_with_delimiter(Item.count)}"
  end

  def column_charts_options
    {
      backgroundColor: "white",
      colors: ["#FBBE1E"],
    }
  end

  def pie_charts_options
    {
      backgroundColor: {
        fill: "white",
        stroke: "white",
      },
      pieSliceBorderColor: "#222",
      pieSliceText: "label",
      pieSliceTextStyle: { color: "black", fontSize: "12" },
      legend: { position: "none" },
    }
  end

  def items_per_month
    Item.group_by_month(:created_at, format: "%b %Y").count
  end

  def items_per_day_of_week
    days_of_week = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)
    result = {}
    Item.group_by_day_of_week(:created_at).count.map do |k, v|
      result[days_of_week[k.to_i]] = v
    end
    result
  end

  def random_discogsless_url
    item_url(Item.where("discogs_url IS NULL").sample)
  end

  def top_10(field)
    @total_count ||= Item.count
    stats = @item_stats || ItemStats.new
    stats.top_10(field).map do |value, count|
      percentage = count * 100.0 / @total_count
      "<p><strong>#{value}</strong>: #{number_with_delimiter(count)}: <em>#{percentage.round(2)}%</em></p>"
    end.join.html_safe
  end

  def field_headers
    ["Title", "Artist", "Year", "Label", "Format", "Condition", "Color", "Price Paid", "Notes"]
  end
end
