namespace :item_count do
  desc "This autofills the item_counts table with entries for every day"
  task backfill: :environment do
    start_date = Item.unscoped.order("created_at ASC").select("created_at").first.created_at.to_date
    (start_date..Date.today).each do |date|
      puts "Processing #{date}"
      ItemCount.update_or_create_day(date)
    end
  end
end
