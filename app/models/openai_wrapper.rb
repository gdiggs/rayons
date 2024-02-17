class OpenaiWrapper
  EMBEDDING_MODEL = "text-embedding-3-small".freeze

  OpenAI.configure do |config|
    config.access_token = ENV.fetch("OPENAI_API_KEY")
  end

  def create_embedding(text)
    client = OpenAI::Client.new
    response = client.embeddings(
      parameters: {
        model: EMBEDDING_MODEL,
        input: text,
      }
    )

    response.dig("data", 0, "embedding")
  end
end
