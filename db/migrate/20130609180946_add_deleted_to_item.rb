class AddDeletedToItem < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :deleted, :boolean, default: "f"
  end
end
