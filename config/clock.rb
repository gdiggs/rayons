require './config/boot'
require './config/environment'

module Clockwork
  configure do |config|
    config[:tz] = "America/New_York"
  end

  every(1.day, 'Backup to Dropbox', at: '01:00') do
    raise "Must have Dropbox access key in `ENV['DROPBOX_ACCESS_TOKEN']`" if !ENV['DROPBOX_ACCESS_TOKEN']

    client = DropboxClient.new(ENV['DROPBOX_ACCESS_TOKEN'])
    csv_data = Item.to_csv
    response = client.put_file("rayons_backup_#{Time.now.to_i}.csv", csv_data)
  end

  every(1.day, 'Backfill Item Counts', at: '00:00') do
    start_date = Item.unscoped.order('created_at ASC').select('created_at').first.created_at.to_date
    (start_date..Date.today).each do |date|
      puts "Processing #{date}"
      ItemCount.update_or_create_day(date)
    end
  end
end
