class ItemEmbeddingGenerator
  def generate
    openai = OpenaiWrapper.new
    items_to_backfill.find_each do |item|
      embedding = openai.create_embedding(item.as_embedding)
      item.embedding = embedding
      item.save!
    end
  end

  private

  def items_to_backfill
    Item.where(embedding: nil)
  end
end
