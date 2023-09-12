class ItemImporter
  def initialize(urls, notes = nil)
    @urls = urls
    @notes = notes
  end

  def import
    errors = []
    items = []

    urls.each do |url|
      item = DiscogsImporter.new(url).import

      if notes.present?
        item.notes = notes
        item.save!
      end

      items << item
    rescue StandardError => e
      errors << "Error importing #{url}: #{e}"
    end

    [items, errors]
  end

  private

  attr_reader :urls, :notes
end
