class SetDeletedOnTracks < ActiveRecord::Migration[6.0]
  def change
    Track.
      unscoped.
      where(deleted: nil).
      in_batches.
      update_all(deleted: false)
  end
end
