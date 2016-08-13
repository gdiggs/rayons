require "discogs"

class DiscogsImporter
  FORMATS = {
    "45 RPM" => '7"',
    "LP" => '12"',
  }.freeze

  def initialize(url)
    @url = url
  end

  def import
    Item.create!(item_attributes)
  end

  private

  attr_reader :url

  def discogs_id
    @discogs_id ||= url.gsub(/.*\/release\/(\d+)/, '\1')
  end

  def discogs_release
    @release ||= discogs_wrapper.get_release(discogs_id)
  end

  def discogs_wrapper
    @discogs_wrapper ||= Discogs::Wrapper.new(
      "Rayons #{Rails.env}",
      app_key: ENV["DISCOGS_APP_KEY"],
      app_secret: ENV["DISCOGS_APP_SECRET"],
    )
  end

  def clean_field(str)
    str.gsub(/\(\d+\)$/, "").strip
  end

  def artist
    discogs_release["artists"].map { |a| clean_field(a["name"]) }.join(" / ")
  end

  def format
    fmt = discogs_release["formats"].first["descriptions"].first
    FORMATS[fmt] || fmt
  end

  def item_attributes
    {
      artist: artist,
      color: discogs_release["formats"].first["text"] || "Black",
      condition: "",
      discogs_url: url,
      format: format,
      label: clean_field(discogs_release["labels"].first["name"]),
      price_paid: "$0.00",
      title: discogs_release["title"],
      year: discogs_release["year"],
    }
  end
end
