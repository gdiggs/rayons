class Item < ActiveRecord::Base
  before_validation :blank_discogs

  validates_presence_of :price_paid
  validates_format_of :discogs_url, :with => URI::regexp(['http', 'https']), :allow_nil => true

  scope :added_on_day, lambda { |date| where ["created_at >= ? AND created_at <= ?", date.to_date, (date+1.day).to_date] }

  default_scope { where(:deleted => false) }

  SORT_ORDER = ['artist', 'title', 'year', 'label', 'format'].freeze

  def self.counts_by_day
    times = Item.group_by_day(:created_at).order('day asc').count
    Hash[times.map { |k, v| [k.to_i, v] }]
  end

  def self.growth_by_week
    times = Item.group_by_week(:created_at).order('week asc').count
    result = {}
    times.values.each_with_index do |time, i|
      # Get sum of values up to this point
      result[times.keys[i]] = times.values[0..i].inject(:+)
    end
    result
  end

  def self.prices
    sql = Item.select(:price_paid).sorted('price_paid').to_sql
    connection.select_values(sql).map{ |p| p.gsub(/\$/, '').to_f }
  end

  def self.significant_prices
    {
      :max_price => Item.prices.last.round(2),
      :min_price => Item.prices.first.round(2),
      :avg_price => Item.prices.average.round(2),
      :median_price => Item.prices.median.round(2)
    }
  end

  def self.stats_for_field(field)
    self.select(field).group(field).order("count_#{field} DESC").count
  end

  def self.price_stats
    self.select(:price_paid).group(:price_paid).order("to_number(price_paid, '9999999.99')").count
  end

  def self.search(query = "")
    query = query.to_s
    if !query.present?
      self.all
    elsif query == query.to_i.to_s
      self.basic_search(query) | self.where(['year = ?', query])
    else
      self.basic_search(query)
    end
  end

  def self.sorted(first = SORT_ORDER[0], direction = 'ASC')
    first ||= SORT_ORDER[0]
    direction ||= 'ASC'

    first = "to_number(price_paid, '9999999.99')" if first == 'price_paid'
    sort_order = [first] + (SORT_ORDER - [first])
    sort_order = sort_order.map { |s| "#{s} #{direction}" }

    self.order(sort_order.join(','))
  end

  def self.to_csv
    headers = ['title', 'artist', 'year', 'label', 'format', 'condition', 'color', 'price_paid', 'discogs_url', 'created_at', 'updated_at']
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
    raise "You must include a file" if !file

    # construct an array of hashes from the data
    # from http://snippets.dzone.com/posts/show/3899
    csv_data = CSV.read(file.tempfile)
    headers = csv_data.shift.map {|i| i.to_s }
    string_data = csv_data.map {|row| row.map {|cell| cell.to_s.force_encoding('utf-8') } }
    array_of_hashes = string_data.map {|row| Hash[*headers.zip(row).flatten] }

    items = []

    Item.transaction do
      array_of_hashes.each { |attrs| items << Item.create(attrs) }
    end

    items
  end

  def destroy
    self.deleted = true
    self.save!
  end

  class InvalidFieldError < RuntimeError; end

  private
  def blank_discogs
    self.discogs_url = nil if self.discogs_url.blank?
  end

end
