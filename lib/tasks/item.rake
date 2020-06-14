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

      if (count % 25).zero?
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

  desc "This suggests discogs urls for items with it missing"
  task suggest_discogs_urls: :environment do
    count = 1

    puts "title,artist,url,discogs_url"
    Item.where(discogs_url: [nil, ""]).find_each do |item|
      if (count % 40).zero?
        sleep 60
      end
      count += 1

      result = DiscogsWrapper.new.search_releases(item.title, item.artist)["results"].first
      discogs_url = result && "https://discogs.com#{result["uri"]}"
      url = Rails.application.routes.url_helpers.edit_item_url(item, host: ActionMailer::Base.smtp_settings[:domain])

      print CSV.generate_line([item.title, item.artist, url, discogs_url])
    end
  end

  desc "This backfills tracks from Discogs"
  task backfill_tracks: :environment do
    count = 1

    Item.where.not(discogs_url: [nil, ""]).find_each do |item|
      next if item.tracks.exists?

      if (count % 25).zero?
        puts "Sleeping 1 minute to wait for Discogs rate limit"
        sleep 60
      end

      puts "Updating #{item.id}: #{item.title} (#{item.artist})"

      release = DiscogsRelease.new(item)
      tracklist = release.tracklist

      tracklist.each do |entry|
        next if entry["position"].blank?

        artist = item.artist

        if entry["artists"]
          artist = entry["artists"].first["name"].gsub(/\(\d+\)$/, "").strip
        end

        item.tracks.create!(
          artist: artist,
          duration: entry["duration"],
          name: entry["title"],
          number: entry["position"],
        )
      end

      count += 1
    rescue DiscogsWrapper::ReleaseNotFoundError
      puts "Skipping #{item.id}: #{item.title} (#{item.artist}). Discogs release not found"
      count += 1
      next
    end
  end
end
