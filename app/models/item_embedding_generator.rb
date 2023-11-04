class ItemEmbeddingGenerator
  def generate
    openai = OpenaiWrapper.new

    total = items_to_backfill.count
    i = 1

    items_to_backfill.find_each do |item|
      puts "[#{i}/#{total}]: #{item.artist} - #{item.title}"
      embedding = openai.create_embedding(item.as_embedding)
      item.embedding = embedding
      item.save!
      i += 1
    end
  end

  private

  def items_to_backfill
    Item.where.
      not(embedding_version: Item::EMBEDDING_VERSION).
      or(Item.where(embedding_version: nil)).
      or(Item.where(embedding: nil))
  end
end
