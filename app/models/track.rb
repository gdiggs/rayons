class Track < ApplicationRecord
  belongs_to :item

  validates_presence_of :artist,
    :item_id,
    :name
end
