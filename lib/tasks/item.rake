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

  desc "This backfills genres and styles from Discogs"
  task backfill_genres: :environment do
    count = 1
    Item.where.not(discogs_url: [nil, ""]).find_each do |item|
      next if item.genres.present? || item.styles.present?

      if count % 25 == 0
        puts "Sleeping 1 minute to wait for Discogs rate limit"
        sleep 60
      end

      release = DiscogsRelease.new(item)
      item.genres = release.genres || []
      item.styles = release.styles || []
      item.save!
      count += 1
    rescue DiscogsWrapper::ReleaseNotFoundError
      puts "Skipping #{item.id}: #{item.title} (#{item.artist}). Discogs release not found"
      count += 1
      next
    end
  end
end
