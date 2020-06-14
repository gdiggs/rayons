class Track < ApplicationRecord
  belongs_to :item

  validates_presence_of :artist, :item_id, :name

  default_scope { where(deleted: false) }

  def destroy
    self.deleted = true
    save!
  end
end
