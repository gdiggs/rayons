class AddIndexesToItems < ActiveRecord::Migration[4.2]
  def change
    add_index :items, :title
    add_index :items, :artist
    add_index :items, :year
    add_index :items, :label
    add_index :items, :format
    add_index :items, :condition
    add_index :items, :price_paid
    add_index :items, :created_at
    add_index :items, :updated_at
    add_index :items, :color
  end
end
