class AddDeletedToTracks < ActiveRecord::Migration[6.0]
  def change
    add_column :tracks, :tracks, :string
    add_column :tracks, :deleted, :boolean
  end
end
