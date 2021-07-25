class Loaders::BelongsToLoader < GraphQL::Batch::Loader
  def initialize(model)
    @model = model
  end

  def perform(ids)
    @model.where(id: ids.uniq).each do |record|
      fulfill(record.id, record)
    end

    ids.each do |id|
      fulfill(id, nil) unless fulfilled?(id)
    end
  end
end
