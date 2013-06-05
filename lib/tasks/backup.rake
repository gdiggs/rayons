desc "This backs up the collection to gist"
task :backup => :environment do
  raise "Must have gist token in `ENV['GIST_TOKEN']`" if !ENV['GIST_TOKEN']

  CSV_URL = "https://x-vinyl.herokuapp.com/items.csv"

  ### GET CSV
  csv_data = Typhoeus.get(CSV_URL).body
  csv_data = csv_data.encode("UTF-8", "ISO-8859-15")

  ### SAVE TO GIST
  gist_options = {
    access_token: ENV['GIST_TOKEN'],
    filename: "rayons_backup_#{Time.now.to_i}.csv",
    public: false
  }

  Gist.gist(csv_data, gist_options)
end
