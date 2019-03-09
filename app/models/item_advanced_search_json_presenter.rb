class ItemAdvancedSearchJSONPresenter < ItemJSONPresenter
  def initialize(options = {})
    super
    @search = options[:q].dup
  end

  private

  def pagy_objects
    @pagy_objects ||= pagy(Item.sorted(sort, direction).advanced_search(search))
  end
end
