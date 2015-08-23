class ItemAdvancedSearchJSONPresenter < ItemJSONPresenter
  def initialize(options = {})
    super
    @search = options[:q].dup
  end

  def items
    Rails.logger.info "ASRERE #{search}"
    Item.sorted(sort, direction).advanced_search(search).page(page)
  end
end
