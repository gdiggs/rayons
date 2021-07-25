class ItemImporter
  def initialize(urls)
    @urls = urls
  end

  def import
    errors = []
    items = []

    urls.each do |url|
      items << DiscogsImporter.new(url).import
    rescue StandardError => e
      errors << "Error importing #{url}: #{e}"
    end

    [items, errors]
  end

  private

  attr_reader :urls
end
