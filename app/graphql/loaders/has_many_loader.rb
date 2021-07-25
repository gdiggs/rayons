class Loaders::HasManyLoader < GraphQL::Batch::Loader
  def initialize(model, column)
    @model = model
    @column = column
  end

  def perform(relation_ids)
    records_by_relation_id = @model.where({ @column => relation_ids.uniq }).group_by do |result|
      result.public_send(@column)
    end

    relation_ids.each do |id|
      fulfill(id, records_by_relation_id[id] || [])
    end
  end
end
