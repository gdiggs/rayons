class ItemJSONPresenter
  attr_reader :sort, :direction, :search, :page

  def initialize(options = {})
    @sort = options[:sort]
    @direction = options[:direction]
    @search = options[:search]
    @page = [options[:page].to_i, 1].max
  end

  def as_json
    { items: items, page: page }.merge(pagination.as_json)
  end

  def to_json
    as_json.to_json
  end

  def cache_key
    [self.class.name, Item.unscoped.maximum(:updated_at).to_i, sort, direction, search, page, 2]
  end

  def items
    Item.sorted(sort, direction).search(search).page(page)
  end

  def pagination
    PageEntriesInfoDecorator.new(items)
  end
end
