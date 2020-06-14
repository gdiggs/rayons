require "spec_helper"

describe DiscogsImporter, type: :model do
  describe "#import" do
    it "handles odd formats" do
      id = "3916848"
      url = "https://www.discogs.com/NOFX-The-Decline/release/3916848"
      release = {
        "styles" => %w[Punk Ska],
        "videos" =>
        [
          {
            "duration" => 1101,
            "description" => "NOFX - The Decline (Official Full Album Version)",
            "embed" => true,
            "uri" => "https://www.youtube.com/watch?v=qnFVMkTWaBw",
            "title" => "NOFX - The Decline (Official Full Album Version)",
          },
        ],
        "series" => [],
        "labels" =>
        [
          {
            "name" => "Fat Records", "entity_type" => "1", "catno" => "FAT605", "resource_url" => "https://api.discogs.com/labels/33296", "id" => 33_296, "entity_type_name" => "Label"
          },
        ],
        "year" => 1999,
        "community" =>
        {
          "status" => "Accepted",
          "rating" => { "count" => 7, "average" => 5.0 },
          "have" => 41,
          "contributors" =>
          [
            { "username" => "throckk", "resource_url" => "https://api.discogs.com/users/throckk" }, { "username" => "br00tal", "resource_url" => "https://api.discogs.com/users/br00tal" }
          ],
          "want" => 279,
          "submitter" => { "username" => "throckk", "resource_url" => "https://api.discogs.com/users/throckk" },
          "data_quality" => "Needs Vote",
        },
        "artists" => [
          { "join" => "", "name" => "NOFX (3)", "anv" => "", "tracks" => "", "role" => "", "resource_url" => "https://api.discogs.com/artists/253281", "id" => 253_281 },
        ],
        "images" => [
          { "uri" => "", "height" => 200, "width" => 200, "resource_url" => "", "type" => "primary", "uri150" => "" },
        ],
        "format_quantity" => 1,
        "id" => 3_916_848,
        "genres" => ["Rock"],
        "thumb" => "",
        "num_for_sale" => 0,
        "title" => "The Decline",
        "date_changed" => "2013-09-25T11:48:28-07:00",
        "master_id" => 39_614,
        "lowest_price" => nil,
        "status" => "Accepted",
        "released_formatted" => "23 Nov 1999",
        "estimated_weight" => 230,
        "master_url" => "https://api.discogs.com/masters/39614",
        "released" => "1999-11-23",
        "date_added" => "2012-10-01T14:43:19-07:00",
        "tracklist" =>
        [
          { "duration" => "", "position" => "A1", "type_" => "track", "title" => "The Decline" }, { "duration" => "", "position" => "B1", "type_" => "track", "title" => "Clams Have Feelings Too" }
        ],
        "extraartists" => [],
        "country" => "US",
        "notes" => "155 on clear vinyl.  B-side is an alternate version of Clams Have Feelings Too.",
        "identifiers" => [],
        "companies" => [],
        "uri" => "https://www.discogs.com/NOFX-The-Decline/release/3916848",
        "formats" => [
          {"name" => "Box Set", "qty" => 1}, { "descriptions" => ["LP"], "text" => "Clear Vinyl", "name" => "Vinyl", "qty" => "1" }],
        "resource_url" => "https://api.discogs.com/releases/3916848",
        "data_quality" => "Needs Vote",
      }

      wrapper = double(get_release: release)
      expect(DiscogsWrapper).to receive(:new).and_return(wrapper)

      item = DiscogsImporter.new(url).import

      expect(item.format).to be_nil
    end

    it "creates an Item" do
      id = "3916848"
      url = "https://www.discogs.com/NOFX-The-Decline/release/3916848"
      release = {
        "styles" => %w[Punk Ska],
        "videos" =>
        [
          {
            "duration" => 1101,
            "description" => "NOFX - The Decline (Official Full Album Version)",
            "embed" => true,
            "uri" => "https://www.youtube.com/watch?v=qnFVMkTWaBw",
            "title" => "NOFX - The Decline (Official Full Album Version)",
          },
        ],
        "series" => [],
        "labels" =>
        [
          {
            "name" => "Fat Records", "entity_type" => "1", "catno" => "FAT605", "resource_url" => "https://api.discogs.com/labels/33296", "id" => 33_296, "entity_type_name" => "Label"
          },
        ],
        "year" => 1999,
        "community" =>
        {
          "status" => "Accepted",
          "rating" => { "count" => 7, "average" => 5.0 },
          "have" => 41,
          "contributors" =>
          [
            { "username" => "throckk", "resource_url" => "https://api.discogs.com/users/throckk" }, { "username" => "br00tal", "resource_url" => "https://api.discogs.com/users/br00tal" }
          ],
          "want" => 279,
          "submitter" => { "username" => "throckk", "resource_url" => "https://api.discogs.com/users/throckk" },
          "data_quality" => "Needs Vote",
        },
        "artists" => [
          { "join" => "", "name" => "NOFX (3)", "anv" => "", "tracks" => "", "role" => "", "resource_url" => "https://api.discogs.com/artists/253281", "id" => 253_281 },
        ],
        "images" => [
          { "uri" => "", "height" => 200, "width" => 200, "resource_url" => "", "type" => "primary", "uri150" => "" },
        ],
        "format_quantity" => 1,
        "id" => 3_916_848,
        "genres" => ["Rock"],
        "thumb" => "",
        "num_for_sale" => 0,
        "title" => "The Decline",
        "date_changed" => "2013-09-25T11:48:28-07:00",
        "master_id" => 39_614,
        "lowest_price" => nil,
        "status" => "Accepted",
        "released_formatted" => "23 Nov 1999",
        "estimated_weight" => 230,
        "master_url" => "https://api.discogs.com/masters/39614",
        "released" => "1999-11-23",
        "date_added" => "2012-10-01T14:43:19-07:00",
        "tracklist" =>
        [
          { "duration" => "", "position" => "A1", "type_" => "track", "title" => "The Decline" }, { "duration" => "", "position" => "B1", "type_" => "track", "title" => "Clams Have Feelings Too" }
        ],
        "extraartists" => [],
        "country" => "US",
        "notes" => "155 on clear vinyl.  B-side is an alternate version of Clams Have Feelings Too.",
        "identifiers" => [],
        "companies" => [],
        "uri" => "https://www.discogs.com/NOFX-The-Decline/release/3916848",
        "formats" => [{ "descriptions" => ["LP"], "text" => "Clear Vinyl", "name" => "Vinyl", "qty" => "1" }],
        "resource_url" => "https://api.discogs.com/releases/3916848",
        "data_quality" => "Needs Vote",
      }

      wrapper = double(get_release: release)
      expect(DiscogsWrapper).to receive(:new).and_return(wrapper)

      item = DiscogsImporter.new(url).import

      expect(item).to be_a(Item)
      expect(item).to be_valid
      expect(item.artist).to eq("NOFX")
      expect(item.title).to eq("The Decline")
      expect(item.discogs_url).to eq(url)
      expect(item.format).to eq("12\"")
      expect(item.label).to eq("Fat")
      expect(item.genres).to eq(["Rock"])
      expect(item.styles).to eq(%w[Punk Ska])
    end

    it "creates tracks" do
      id = "3916848"
      url = "https://www.discogs.com/NOFX-The-Decline/release/3916848"
      release = {
        "styles" => %w[Punk Ska],
        "videos" =>
        [
          {
            "duration" => 1101,
            "description" => "NOFX - The Decline (Official Full Album Version)",
            "embed" => true,
            "uri" => "https://www.youtube.com/watch?v=qnFVMkTWaBw",
            "title" => "NOFX - The Decline (Official Full Album Version)",
          },
        ],
        "series" => [],
        "labels" =>
        [
          {
            "name" => "Fat Records", "entity_type" => "1", "catno" => "FAT605", "resource_url" => "https://api.discogs.com/labels/33296", "id" => 33_296, "entity_type_name" => "Label"
          },
        ],
        "year" => 1999,
        "community" =>
        {
          "status" => "Accepted",
          "rating" => { "count" => 7, "average" => 5.0 },
          "have" => 41,
          "contributors" =>
          [
            { "username" => "throckk", "resource_url" => "https://api.discogs.com/users/throckk" }, { "username" => "br00tal", "resource_url" => "https://api.discogs.com/users/br00tal" }
          ],
          "want" => 279,
          "submitter" => { "username" => "throckk", "resource_url" => "https://api.discogs.com/users/throckk" },
          "data_quality" => "Needs Vote",
        },
        "artists" => [
          { "join" => "", "name" => "NOFX (3)", "anv" => "", "tracks" => "", "role" => "", "resource_url" => "https://api.discogs.com/artists/253281", "id" => 253_281 },
        ],
        "images" => [
          { "uri" => "", "height" => 200, "width" => 200, "resource_url" => "", "type" => "primary", "uri150" => "" },
        ],
        "format_quantity" => 1,
        "id" => 3_916_848,
        "genres" => ["Rock"],
        "thumb" => "",
        "num_for_sale" => 0,
        "title" => "The Decline",
        "date_changed" => "2013-09-25T11:48:28-07:00",
        "master_id" => 39_614,
        "lowest_price" => nil,
        "status" => "Accepted",
        "released_formatted" => "23 Nov 1999",
        "estimated_weight" => 230,
        "master_url" => "https://api.discogs.com/masters/39614",
        "released" => "1999-11-23",
        "date_added" => "2012-10-01T14:43:19-07:00",
        "tracklist" =>
        [
          { "duration" => "18:00", "position" => "A1", "type_" => "track", "title" => "The Decline" }, { "duration" => "", "position" => "B1", "type_" => "track", "title" => "Clams Have Feelings Too" }, {"position"=>"", "type_"=>"track", "title"=>"", "duration"=>""}
        ],
        "extraartists" => [],
        "country" => "US",
        "notes" => "155 on clear vinyl.  B-side is an alternate version of Clams Have Feelings Too.",
        "identifiers" => [],
        "companies" => [],
        "uri" => "https://www.discogs.com/NOFX-The-Decline/release/3916848",
        "formats" => [{ "descriptions" => ["LP"], "text" => "Clear Vinyl", "name" => "Vinyl", "qty" => "1" }],
        "resource_url" => "https://api.discogs.com/releases/3916848",
        "data_quality" => "Needs Vote",
      }

      wrapper = double(get_release: release)
      expect(DiscogsWrapper).to receive(:new).and_return(wrapper)

      item = DiscogsImporter.new(url).import
      tracks = item.tracks

      expect(item).to be_a(Item)
      expect(item).to be_valid

      expect(tracks.count).to eq 2

      decline = tracks.first
      expect(decline.name).to eq("The Decline")
      expect(decline.duration).to eq("18:00")
      expect(decline.number).to eq("A1")
      expect(decline.artist).to eq("NOFX")
      expect(decline.item).to eq(item)
    end
  end
end
