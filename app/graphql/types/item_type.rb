module Types
  class ItemType < Types::BaseObject
    description "An item in the collection"

    field :id, ID, null: false
    field :title, String, null: true
    field :artist, String, null: true
    field :year, Int, null: true
    field :label, String, null: true
    field :format, String, null: true
    field :condition, String, null: true
    field :color, String, null: true
    field :price_paid, String, null: false
    field :discogs_url, String, null: true
    field :notes, String, null: true
    field :tracks, [TrackType], null: false

    def tracks
      Loaders::HasManyLoader.for(Track, :item_id).load(object.id)
    end
  end
end
