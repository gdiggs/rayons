class AddDeletedToItem < ActiveRecord::Migration
  def change
    add_column :items, :deleted, :boolean, :default => 'f'
  end
end
