require 'discogs'
require 'typhoeus'

class DiscogsRelease
  attr_accessor :release

  def initialize(item)
    @wrapper = Discogs::Wrapper.new("Rayons #{Rails.env}")
    if item.discogs_url.present?
      discogs_id = item.discogs_url.gsub(/.*\/release\/(\d+)/, '\1')
      self.release = @wrapper.get_release(discogs_id)
    end
  end

  def image_url
    images.first.uri.gsub('http://api.discogs.com', 'http://s.pixogs.com') rescue nil
  end

  def image
    if image_url
       t = Typhoeus.get(image_url)
       Base64.encode64 t.body
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
end
