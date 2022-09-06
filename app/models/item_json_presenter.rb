class ItemJsonPresenter
  include Pagy::Backend
  attr_reader :sort, :direction, :search, :page

  def initialize(options = {})
    @sort = options[:sort]
    @direction = options[:direction]
    @search = options[:search]
    @page = [options[:page].to_i, 1].max
  end

  def as_json
    {
      count: pagination.count,
      items: items,
      page: page,
      pages: pagination.pages,
    }
  end

  def to_json
    as_json.to_json
  end

  def cache_key
    [self.class.name, Item.unscoped.maximum(:updated_at).to_i, sort, direction, search, page, 2]
  end

  def items
    pagy_objects[1]
  end

  def pagination
    pagy_objects[0]
  end

  private

  def params
    {
      page: page,
    }
  end

  def pagy_objects
    @pagy_objects ||= pagy(Item.sorted(sort, direction).search(search))
  end
end
