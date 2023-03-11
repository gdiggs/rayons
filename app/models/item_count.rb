class ItemCount < ActiveRecord::Base
  validates_uniqueness_of :date

  def self.by_week
    ItemCount.order(:date).map { |i| [i.date, i.num] }
  end

  def self.update_or_create_day(date)
    # number of items is the number of total items minus the number of deleted ones
    item_count = Item.unscoped.where(["created_at < ?", date.end_of_day]).count - Item.unscoped.where(["updated_at < ? AND deleted IS TRUE", date.end_of_day]).count
    ItemCount.find_or_initialize_by(date: date).update(num: item_count)
  end
end
