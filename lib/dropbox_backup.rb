class DropboxBackup
  def backup
    client.put_file(filename, csv_data)
  end

  private

  def filename
    "rayons_backup_#{Time.now.to_i}.csv"
  end

  def csv_data
    Item.to_csv
  end

  def client
    if ENV["DROPBOX_ACCESS_TOKEN"]
      DropboxClient.new(ENV["DROPBOX_ACCESS_TOKEN"])
    else
      raise "Must have Dropbox access key in `ENV['DROPBOX_ACCESS_TOKEN']`"
    end
  end
end
