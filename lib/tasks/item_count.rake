namespace :item_count do
  desc "This autofills the item_counts table with entries for every day"
  task :backfill => :environment do
    start_date = Item.unscoped.order('created_at ASC').select('created_at').first.created_at.to_date
    (start_date..Date.today).each do |date|
      item_count = Item.unscoped.where(['created_at < ?', date.end_of_day]).count - Item.unscoped.where(['created_at < ? AND deleted IS TRUE', date.end_of_day]).count
      puts "On #{date}, there were #{item_count} items"
      ItemCount.create!(date: date, num: item_count)
    end
  end
end
