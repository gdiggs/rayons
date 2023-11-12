require "digest"

class ItemEmbeddingGenerator
  def generate
    openai = OpenaiWrapper.new

    Item.all.find_each do |item|
      next if item.embedding_md5 == md5(item.as_embedding)

      Rails.logger.info("Embedding: #{item.artist} - #{item.title}")
      embedding = openai.create_embedding(item.as_embedding)
      item.embedding = embedding
      item.embedding_md5 = md5(item.as_embedding)
      item.save!
    end
  end

  private

  def md5(text)
    Digest::MD5.hexdigest(text)
  end
end
