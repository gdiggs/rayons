class Item < ActiveRecord::Base
  attr_accessible :artist, :condition, :format, :label, :price_paid, :title, :year, :color, :updated_at, :created_at

  validates_presence_of :price_paid

  scope :added_on_day, lambda { |date| where ["created_at >= ? AND created_at <= ?", date.to_date, (date+1.day).to_date] }

  SORT_ORDER = ['artist', 'title', 'year', 'label', 'format'].freeze
  STAT_FIELDS = (Item.column_names - ["created_at", "updated_at", "id"]).freeze

  after_destroy :invalidate_cache

  def self.average_price
    self.prices.inject(:+) / self.prices.count
  end

  def self.median_price
    count = self.prices.count
    if count % 2 == 1
      self.prices[count/2]
    else
      prices = self.prices
      (prices[count/2 - 1] + prices[count/2]).to_f / 2
    end
  end

  def self.prices
    Item.select(:price_paid).sorted('price_paid').map{ |p| p.price_paid.gsub(/\$/, '').to_f }
  end

  def self.stats
    results = {}
    STAT_FIELDS.each do |field|
      results[field] = self.stats_for_field(field)
    end
    results
  end

  def self.stats_for_field(field)
    data = {}
    stats = self.count(field, :group => field, :order => "count_#{field} DESC")

    stats.each do |val, count|
      if count == 1
        data["Other"] = data["Other"].to_i + 1
      else
        data[val.to_s] = count
      end
    end

    data
  end

  def self.search(query = "")
    if query == query.to_i.to_s
      self.basic_search(query) | self.where(['year = ?', query])
    else
      self.basic_search(query)
    end
  end

  def self.sorted(first = SORT_ORDER[0], direction = 'ASC')
    first = "to_number(price_paid, '9999999.99')" if first == 'price_paid'
    sort_order = [first] + (SORT_ORDER - [first])
    sort_order = sort_order.map { |s| "#{s} #{direction}" }

    self.order(sort_order.join(','))
  end

  def self.to_csv
    headers = ['title', 'artist', 'year', 'label', 'format', 'condition', 'color', 'price_paid', 'created_at', 'updated_at']
    csv = CSV.generate do |c|
      c << headers
      Item.all.each do |item|
        c << headers.map { |h| item.send(h) }
      end
    end
    csv
  end

  def self.words_for_field(field)
    raise InvalidFieldError if !Item.column_names.include?(field.to_s)

    # Get a hash of the words in a field
    items = Item.select(field.to_sym).map{ |i| i.send(field.to_sym).to_s.split(/[\s\/,\(\)]+/) }.flatten.group_by{ |v| v }
    # return the frequency of each word
    Hash[items.map{|k,v| [k, v.count] }]
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

  class InvalidFieldError < RuntimeError; end

  private
  # Invalidates the collection cache, which is made against the max updated_at
  def invalidate_cache
    Item.last.touch
  end
end
