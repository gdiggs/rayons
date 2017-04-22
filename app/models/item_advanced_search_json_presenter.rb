class ItemAdvancedSearchJSONPresenter < ItemJSONPresenter
  def initialize(options = {})
    super
    @search = options[:q].dup
  end

  def items
    Item.sorted(sort, direction).advanced_search(search).page(page)
  end
end
