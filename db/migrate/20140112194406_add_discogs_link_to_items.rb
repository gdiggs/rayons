class AddDiscogsLinkToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :discogs_url, :text
  end
end
