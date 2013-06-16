module ItemsHelper
  def google_column_charts_options
    {
      backgroundColor: '#2f2f2f',
      colors: ['#77aacc']
    }
  end

  def google_pie_charts_options
    {
      backgroundColor: {
        fill: '#2F2F2F',
        stroke: '#2F2F2F'
      },
      pieSliceBorderColor: '#2F2F2F',
      pieSliceText: 'label',
      pieSliceTextStyle: { color: 'black', fontSize: '12' },
      legend: {position: 'none'}
    }
  end

  def items_per_month
    result = {}
    Item.group_by_month(:created_at).order('month asc').count.map do |k,v|
      result[Time.parse(k).strftime("%b %Y")] = v
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

end
