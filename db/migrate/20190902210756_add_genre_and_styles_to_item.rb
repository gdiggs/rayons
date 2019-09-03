class AddGenreAndStylesToItem < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :genres, :text, array: true, default: []
    add_column :items, :styles, :text, array: true, default: []
  end
end
