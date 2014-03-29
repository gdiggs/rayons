class PageEntriesInfoDecorator < Draper::CollectionDecorator
  delegate :total_pages, :limit_value, :offset_value, :limit_value, :last_page?, :model_name

  def total_count
    h.number_with_delimiter(object.total_count)
  end
end
