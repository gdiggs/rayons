class AddDiscogsLinkToItems < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :discogs_url, :text
  end
end
