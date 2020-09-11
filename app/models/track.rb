class Track < ApplicationRecord
  belongs_to :item

  validates_presence_of :artist, :item_id, :name

  default_scope { where(deleted: false) }

  def possible_covers
    self.class.where("name = ? AND artist != ?", name, artist)
  end

  def possible_alternates
    self.class.where("name = ? AND artist = ? AND id != ?", name, artist, id)
  end

  def destroy
    self.deleted = true
    save!
  end
end
