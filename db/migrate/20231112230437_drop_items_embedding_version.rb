class DropItemsEmbeddingVersion < ActiveRecord::Migration[7.1]
  def change
    remove_column :items, :embedding_version
  end
end
