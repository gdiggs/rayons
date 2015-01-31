require 'memoist'

class TimeMachine
  extend Memoist

  attr_reader :base_date

  def initialize(date = Time.now)
    @base_date = date.to_date
  end

  def has_items?
    items.present?
  end

  def items
    result = {}

    i = 1
    date = base_date - i.years

    while date >= start_date do
      if (items = Item.where(created_at: date..date.end_of_day)).present?
        result[date] = items
      end

      i += 1
      date = base_date - i.years
    end

    result
  end

  def as_json
    {items: items}
  end

  def to_json
    as_json.to_json
  end

  memoize :items

  private
  def start_date
    @start_date ||= Item.minimum(:created_at)
  end
end
