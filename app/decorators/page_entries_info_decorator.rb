class PageEntriesInfoDecorator < Draper::CollectionDecorator
  delegate :total_pages, :limit_value, :offset_value, :limit_value, :last_page?, :model_name

  def total_count
    h.number_with_delimiter(object.total_count)
  end

  alias :last_page :last_page?

  def as_json(*)
    result = {}
    [:total_pages, :limit_value, :offset_value, :limit_value, :last_page, :total_count].each do |meth|
      result[meth] = self.send(meth)
    end
    result
  end
end
