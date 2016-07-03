class PageEntriesInfoDecorator < SimpleDelegator
  def total_count
    ActiveSupport::NumberHelper.number_to_delimited(super)
  end

  def last_page
    last_page?
  end

  def as_json(*)
    result = {}
    [:total_pages, :limit_value, :offset_value, :limit_value, :last_page, :total_count].each do |meth|
      result[meth] = send(meth)
    end
    result
  end
end
