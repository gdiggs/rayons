require "digest"

class ItemEmbeddingGenerator
  EMBEDDING_VERSION = 2

  def generate
    openai = OpenaiWrapper.new

    Item.all.find_each do |item|
      md5_str = "#{item.as_embedding}/v#{EMBEDDING_VERSION}"
      next if item.embedding_md5 == md5(md5_str)

      Rails.logger.info("Embedding: #{item.artist} - #{item.title}")
      embedding = openai.create_embedding(item.as_embedding)
      item.embedding = embedding
      item.embedding_md5 = md5(md5_str)
      item.save!
    end
  end

  private

  def md5(text)
    Digest::MD5.hexdigest(text)
  end
end
