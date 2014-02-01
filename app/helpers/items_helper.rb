module ItemsHelper
  def google_column_charts_options
    {
      backgroundColor: 'white',
      colors: ['#FBBE1E']
    }
  end

  def google_pie_charts_options
    {
      backgroundColor: {
        fill: 'white',
        stroke: 'white'
      },
      colors: ['#1A739F', '#FBBE1E', '#FB4C1E', '#094A6A', '#2C6079', '#BF9B3F', '#BF5A3F', '#094A6A', '#A77B0A', '#A72B0A', '#49A1CC', '#FDCE53', '#FD7653', '#6AACCC', '#FDD97D', '#FD977D'].shuffle,
      pieSliceBorderColor: '#222',
      pieSliceText: 'label',
      pieSliceTextStyle: { color: 'black', fontSize: '12' },
      legend: {position: 'none'}
    }
  end

  def items_per_month
    result = {}
    Item.group_by_month(:created_at).order('month asc').count.map do |k,v|
      result[k.strftime("%b %Y")] = v
    end
    result
  end

  def items_per_day_of_week
    days_of_week = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
    result = {}
    Item.group_by_day_of_week(:created_at).order("day_of_week asc").count.map do |k,v|
      result[days_of_week[k.to_i]] = v
    end
    result
  end

  def top_10(field)
    @total_count ||= Item.count
    Item.stats_for_field(field).first(10).map do |value, count|
      percentage = count*100.0 / @total_count
      "<p><strong>#{value}</strong>: #{count}: <em>#{percentage.round(2)}%</em></p>"
    end.join.html_safe
  end

  def field_headers
    ['Title', 'Artist', 'Year', 'Label', 'Format', 'Condition', 'Color', 'Price Paid', 'Discogs']
  end

end
