class DiscogsImporter
  FORMATS = {
    "45 RPM" => '7"',
    "LP" => '12"',
  }.freeze

  def initialize(url)
    @url = url
  end

  def import
    Item.transaction do
      item = Item.create!(item_attributes)

      tracklist.each do |entry|
        artist = item.artist

        if entry["artists"]
          artist = clean_field(entry["artists"].first["name"])
        end

        item.tracks.create!(
          artist: artist,
          duration: entry["duration"],
          name: entry["title"],
          number: entry["position"],
        )
      end

      item
    end
  end

  private

  attr_reader :url

  def discogs_id
    @discogs_id ||= url.gsub(/.*\/release\/(\d+).*/, '\1')
  end

  def discogs_release
    @release ||= discogs_wrapper.get_release(discogs_id)
  end

  def discogs_wrapper
    @discogs_wrapper ||= DiscogsWrapper.new
  end

  def clean_field(str)
    str.gsub(/\(\d+\)$/, "").strip
  end

  def artist
    discogs_release["artists"].map { |a| clean_field(a["name"]) }.join(" / ")
  end

  def format
    fmt = discogs_release["formats"].first["descriptions"]&.first
    FORMATS[fmt] || fmt
  end

  def label
    clean_field(discogs_release["labels"].first["name"]).gsub(/ Records\Z/, "")
  end

  def tracklist
    discogs_release["tracklist"].filter { |t| t["position"].present? }
  end

  def item_attributes
    {
      artist: artist,
      color: discogs_release["formats"].first["text"] || "Black",
      condition: "",
      discogs_url: url,
      format: format,
      genres: discogs_release["genres"],
      label: label,
      price_paid: "$0.00",
      styles: discogs_release["styles"],
      title: discogs_release["title"],
      year: discogs_release["year"],
    }
  end
end
