require "memoist"

class ItemOfTheDay
  CACHE_VERSION = 1

  def item
    @item ||=
      Rails.cache.fetch(cache_key) do
        Item.offset(rand(Item.count)).first
      end
  end

  # Follows the spec from Amazon:
  # https://developer.amazon.com/docs/flashbriefing/flash-briefing-skill-api-feed-reference.html#json-single-text-item-example
  def as_json(*)
    {
      uid: "item:#{item.id}",
      updateDate: Date.today.midnight.strftime("%Y-%m-%dT%H:%M:%S.0Z"),
      titleText: "Today's record of the day",
      mainText: item_description,
    }
  end

  private

  def cache_key
    [
      "ItemOfTheDay",
      Date.today,
      CACHE_VERSION,
    ].join("::")
  end

  def item_description
    result = "#{item.title} by #{item.artist}"
    result << " on #{item.label}" if item.label
    result << ". It is a #{item["format"].gsub(/"/, " inch")} record"
    result << " released in #{item.year}" if item.year
    result << ". It was added to your collection on #{item.created_at.strftime("%B %-d, %Y")}."
    result
  end
end
