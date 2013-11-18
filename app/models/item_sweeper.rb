class ItemSweeper < ActionController::Caching::Sweeper
  observe Item

  def after_save(record)
    expire_page(stats_path)
    expire_page(words_for_field_items_path)
  end
end
