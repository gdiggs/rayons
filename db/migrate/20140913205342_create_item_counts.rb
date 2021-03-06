class CreateItemCounts < ActiveRecord::Migration[4.2]
  def change
    create_table :item_counts do |t|
      t.integer :num
      t.date :date
      t.timestamps null: false
    end

    add_index :item_counts, :date
  end
end
