class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.timestamps
      t.text :name
      t.boolean :deleted
    end
  end
end
