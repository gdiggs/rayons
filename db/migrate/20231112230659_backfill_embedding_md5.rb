class BackfillEmbeddingMd5 < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def up
    Item.where(embedding_md5: nil).where.not(embedding: nil).find_each do |item|
      item.embedding_md5 = md5(item.as_embedding)
      item.save!
    end
  end

  private

  def md5(text)
    Digest::MD5.hexdigest(text)
  end
end
