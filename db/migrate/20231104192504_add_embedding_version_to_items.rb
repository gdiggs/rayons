class AddEmbeddingVersionToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :embedding_version, :integer
    add_index :items, :embedding_version
  end
end
