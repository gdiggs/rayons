module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    description "The query root of this schema"

    field :item, ItemType, null: true do
      description "Find an item by ID"
      argument :id, ID, required: true
    end

    field :items, [ItemType], null: false do
      description "Get all items"
      argument :title, String, required: false
      argument :artist, String, required: false
      argument :year, Int, required: false
      argument :label, String, required: false
      argument :format, String, required: false
      argument :condition, String, required: false
      argument :color, String, required: false
      argument :price_paid, String, required: false

      argument :sort, String, required: false
    end

    def item(id:)
      Item.find(id)
    end

    def items(**query_options)
      Item.
        order(query_options.delete(:sort)).
        where(query_options)
    end
  end
end
