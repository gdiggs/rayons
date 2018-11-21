class CreateItems < ActiveRecord::Migration[4.2]
  def change
    create_table :items do |t|
      t.text :title
      t.text :artist
      t.integer :year
      t.text :label
      t.text :format
      t.text :condition
      t.text :price_paid

      t.timestamps
    end
  end
end
