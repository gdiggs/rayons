module Types
  class TrackType < Types::BaseObject
    description "A track"

    field :id, ID, null: false
    field :item, ItemType, null: false
    field :artist, String, null: false
    field :name, String, null: false
    field :number, String, null: true
    field :duration, String, null: true

    def item
      Loaders::BelongsToLoader.for(Item).load(object.item_id)
    end
  end
end
