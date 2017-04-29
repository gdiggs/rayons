require "memoist"
require "open-uri"

class DiscogsRelease
  extend Memoist

  attr_accessor :item, :release

  def initialize(item)
    @wrapper = DiscogsWrapper.new
    self.item = item
    if item.discogs_url.present?
      discogs_id = item.discogs_url.gsub(/.*\/release\/(\d+)/, '\1')
      self.release = @wrapper.get_release(discogs_id)
    end

  rescue Errno::ETIMEDOUT
    self.release = nil
  end

  def extra_info?
    release.present?
  end

  # TODO: go back to using the discogs images somehow
  def image_url
    if release && release.images
      img = release.images.select { |i| i["type"] == "primary" }.sort_by { |i| i["width"] }.last || {}
      img["uri"]
    end
  end

  def styles
    release.styles if release
  end

  def notes
    notes = item.notes.to_s + "\n"
    notes << release.notes.to_s if release
    notes.strip
  end

  def method_missing(meth, *args, &block)
    if release && release.respond_to?(meth)
      release.send(meth, *args, &block)
    else
      super
    end
  end

  def respond_to_missing?(meth)
    super || (release && release.respond_to?(meth))
  end

  memoize :image_url, :notes
end
