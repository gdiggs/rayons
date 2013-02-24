class Item < ActiveRecord::Base
  attr_accessible :artist, :condition, :format, :label, :price_paid, :title, :year, :color, :updated_at, :created_at

  SORT_ORDER = ['artist', 'title', 'year', 'label', 'format']

  def self.search(query = "")
    str = (Item.column_names - ["created_at", "updated_at", "id", "year"]).map { |c| "#{c} ILIKE '%{q}'" }.join(" OR ") % {:q => query}
    str += " OR year = '#{query}'"
    self.where str
  end

  def self.sorted(first = SORT_ORDER[0], direction = 'ASC')
    # pop first to first
    sort_order = [first] + (SORT_ORDER - [first])
    sort_order = sort_order.map { |s| "#{s} #{direction}" }

    self.order(sort_order.join(','))
  end

  # Import a csv file object and create an Item object for each row
  #
  # @param [File] file The csv file to be read
  # @return [Array] The array of items created
  def self.import_csv_file(file)
    # construct an array of hashes from the data
    # from http://snippets.dzone.com/posts/show/3899
    csv_data = CSV.read file
    headers = csv_data.shift.map {|i| i.to_s }
    string_data = csv_data.map {|row| row.map {|cell| cell.to_s.force_encoding('utf-8') } }
    array_of_hashes = string_data.map {|row| Hash[*headers.zip(row).flatten] }

    items = []

    Item.transaction do
      array_of_hashes.each { |attrs| items << Item.create(attrs) }
    end

    items

  end
end
