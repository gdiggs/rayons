class AddIndexesForSearching < ActiveRecord::Migration[4.2]
  def change
    query = ""
    %w(title artist label format condition color).each do |attr|
      query += "create index on items using gin(to_tsvector('english', #{attr}));\n"
    end
    execute query
  end
end
