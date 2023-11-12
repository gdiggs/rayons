class AddEmbeddingMd5ToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :embedding_md5, :string
  end
end
