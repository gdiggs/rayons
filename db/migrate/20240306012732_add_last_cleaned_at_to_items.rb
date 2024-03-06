class AddLastCleanedAtToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :last_cleaned_at, :datetime
    add_index :items, :last_cleaned_at
  end
end
