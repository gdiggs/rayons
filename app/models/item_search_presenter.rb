class ItemSearchPresenter
  def minimum_year
    Item.minimum(:year)
  end

  def maximum_year
    Item.maximum(:year)
  end

  def formats
    Item.group(:format).select(:format).map(&:format).sort
  end

  def conditions
    Item.group(:condition).select(:condition).map(&:condition).sort
  end
end
