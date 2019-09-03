require "net/https"
require "hashie"

class DiscogsWrapper
  class ReleaseNotFoundError < StandardError; end

  BASE_URL = "api.discogs.com".freeze

  def get_release(id)
    get("/releases/#{id}")
  end

  private

  def get(path)
    request =
      Net::HTTP::Get.new(
        path,
        "Authorization" => authorization,
        "User-Agent" => user_agent,
      )

    response = http.request(request)

    if response.code == "200"
      hash = JSON.parse(response.body)
      Hashie::Mash.new(hash)
    elsif response.code == "404"
      raise ReleaseNotFoundError
    else
      raise "Discogs API request failed: #{response.code} #{response.body}"
    end
  end

  def http
    @http ||=
      Net::HTTP.new(BASE_URL, 443).tap do |h|
        h.use_ssl = true
        h.verify_mode = OpenSSL::SSL::VERIFY_PEER
      end
  end

  def authorization
    "Discogs key=#{ENV["DISCOGS_APP_KEY"]}, secret=#{ENV["DISCOGS_APP_SECRET"]}"
  end

  def user_agent
    "Rayons #{Rails.env}"
  end
end
