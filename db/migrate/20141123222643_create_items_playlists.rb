class CreateItemsPlaylists < ActiveRecord::Migration
  def change
    create_table :items_playlists do |t|
      t.timestamps
      t.integer :playlist_id
      t.integer :item_id
      t.boolean :deleted
    end

    add_index :items_playlists, [:playlist_id, :item_id], :unique => true
  end
end
