class AddVectorToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :embedding, :vector, limit: 1536
    add_index :items, :embedding, using: :hnsw, opclass: :vector_cosine_ops
    Item.connection.execute("SET hnsw.ef_search = 100")
  end
end
