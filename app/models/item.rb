class Item < ActiveRecord::Base
  has_and_belongs_to_many :playlists

  before_validation :blank_discogs
  after_save :update_item_counts

  validates_presence_of :price_paid
  validates_format_of :discogs_url, :with => URI::regexp(['http', 'https']), :allow_nil => true

  scope :added_on_day, lambda { |date| where ["created_at >= ? AND created_at <= ?", date.to_date, (date+1.day).to_date] }

  default_scope { where(:deleted => false) }

  SORT_ORDER = ['artist', 'title', 'year', 'label', 'format'].freeze

  def self.search(query = "")
    query = query.to_s
    if !query.present?
      self.all
    elsif query == query.to_i.to_s
      ids = Item.basic_search(query).map(&:id)
      self.where(['year = ? OR id IN (?)', query, ids])
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

  # Generate CSV of items and yield each row to a block
  def self.to_csv
    headers = Item.column_names - ['id', 'deleted']
    csv = ''

    csv << CSV::Row.new(headers, headers, true).to_s
    yield csv if block_given?

    Item.find_each(batch_size: 50) do |item|
      values = item.attributes.values_at(*headers)
      row = CSV::Row.new(headers, values, false).to_s
      yield row if block_given?
      csv << row
    end
    csv
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

  def added_on
    created_at.strftime('%m.%d.%y')
  end

  def as_json(options = {})
    super(options.merge(:methods => :added_on))
  end

  def destroy
    self.deleted = true
    self.save!
  end

  private
  def blank_discogs
    self.discogs_url = nil if self.discogs_url.blank?
  end

  def update_item_counts
    ItemCount.update_or_create_day created_at.to_date
  end

end
