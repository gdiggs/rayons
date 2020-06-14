class CreateTracks < ActiveRecord::Migration[6.0]
  def change
    create_table :tracks do |t|
      t.string :name
      t.string :number
      t.string :artist
      t.string :duration
      t.belongs_to :item, foreign_key: true

      t.timestamps
    end
  end
end
