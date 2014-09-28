class AddNotesToItems < ActiveRecord::Migration
  def change
    add_column :items, :notes, :text
    execute "create index on items using gin(to_tsvector('english', notes));"
  end
end
