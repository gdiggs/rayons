namespace :backup do
  desc "This backs up the collection to Dropbox"
  task :dropbox => :environment do
    raise "Must have Dropbox access key in `ENV['DROPBOX_ACCESS_TOKEN']`" if !ENV['DROPBOX_ACCESS_TOKEN']

    client = DropboxClient.new(ENV['DROPBOX_ACCESS_TOKEN'])
    csv_data = Item.to_csv
    client.put_file("rayons_backup_#{Time.now.to_i}.csv", csv_data)
  end
end
