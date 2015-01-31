require 'discogs'
require 'memoist'
require 'open-uri'

class DiscogsRelease
  extend Memoist

  attr_accessor :item, :release

  def initialize(item)
    @wrapper = Discogs::Wrapper.new("Rayons #{Rails.env}")
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
    query = URI.encode("#{item.artist} #{item.title.gsub(/\(.*\)/, '')} cover")
    response = JSON.parse(open("http://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=8&start=1&q=#{query}").read)
    response['responseData']['results'].first['url'] rescue nil
  end

  ['styles', 'notes'].each do |meth|
    define_method meth do
      if release && release.respond_to?(meth)
        release.send(meth)
      else
        nil
      end
    end
  end

  def method_missing(meth, *args, &block)
    if release && release.respond_to?(meth)
      release.send(meth, *args, &block)
    else
      super
    end
  end

  def respond_to?(meth)
    super || (release && release.respond_to?(meth))
  end

  memoize :image_url
end
