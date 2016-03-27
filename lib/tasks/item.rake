namespace :item do
  desc "This migrates things in parentheses in title to notes"
  task migrate_notes: :environment do
    Item.unscoped.all.find_each do |item|
      if item.title =~ /\((.*)\)/
        note = Regexp.last_match(1)
        print "Item #{item.id} (#{item.title}) might have note '#{note}'. Migrate? (y/n) "
        if STDIN.gets.strip == "y"
          item.title = item.title.gsub(/\((.*)\)/, "").strip
          item.notes = note
          item.save!
        else
          puts "skipping."
        end
      end
    end
  end
end
