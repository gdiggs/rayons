class ItemDiscoverPresenter
  attr_reader :params

  def initialize(params = {})
    @params = params.reject { |_k, v| v.blank? }
  end

  def item
    if query.present?
      Item.where(query).order("RANDOM()").limit(1).first
    end
  end

  private

  def query
    q = []

    params.each do |field, value|
      if %w[genre style].include?(field.to_s)
        q << Item.sanitize_sql_for_assignment(["? = ANY (#{field.to_s.pluralize})", value])
      else
        q << Item.sanitize_sql_for_assignment(field => value)
      end
    end

    q.join(" AND ")
  end
end
