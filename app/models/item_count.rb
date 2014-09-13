class ItemCount < ActiveRecord::Base
  validates_uniqueness_of :date

  def self.create_today
    ItemCount.create!(date: Date.today, num: Item.count)
  end

  def self.by_week
    result = {}
    ItemCount.all.each_slice(7).map(&:first).each { |i| result[i.date] = i.num }
    result
  end
end
