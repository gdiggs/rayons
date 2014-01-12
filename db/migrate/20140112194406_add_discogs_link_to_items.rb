class AddDiscogsLinkToItems < ActiveRecord::Migration
  def change
    add_column :items, :discogs_url, :text
  end
end
