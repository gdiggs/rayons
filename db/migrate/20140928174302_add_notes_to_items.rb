class AddNotesToItems < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :notes, :text
    execute "create index on items using gin(to_tsvector('english', notes));"
  end
end
