class ItemsController < ApplicationController
  before_filter :authorize_item, :only => [:new, :edit, :create, :update, :import, :destroy]
  before_filter :edit_discogs_param, :only => [:index, :create, :update]
  after_filter :expire_pages, :only => [:new, :edit, :create, :update, :import, :destroy]

  caches_page :stats, :counts_by_day
  caches_action :words_for_field, :cache_path => Proc.new { |c| "words_for_field_#{c.params[:field]}" }


  # GET /items/counts_by_day.json
  def counts_by_day
    render json: Item.counts_by_day
  end

  # GET /
  # GET /items
  # GET /items.json
  # GET /items.csv
  def index
    params[:direction] ||= 'ASC'
    params[:sort] ||= Item::SORT_ORDER[0]
    @items = Item.sorted(params[:sort], params[:direction]).search(params[:search])
    @can_edit = policy(Item).edit?

    respond_to do |format|
      format.html
      format.json { render json: @items }
      format.csv { send_data Item.to_csv, :filename => "rayons_#{Time.now.to_i}.csv" }
    end
  end

  # GET /items/latest.json
  def latest
    number_of_items = params[:num].to_i
    number_of_items = 5 if number_of_items.zero?
    @items = Item.order('created_at DESC').limit(number_of_items)
    render json: @items
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(params[:item])

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render json: @item.as_json.merge(item_markup: render_to_string(:partial => 'items/item', :formats => [:html], :locals=>{:item => @item})), status: :created, location: @item }
      else
        default_error_response(format, "new", @item)
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = Item.find(params[:id])
    params[:item] = params[:item].reject { |k,v| !Item.column_names.include?(k) }

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        default_error_response(format, "edit", @item)
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end

  # POST /items/import
  def import
    @items = Item.import_csv_file(params[:file])
    flash[:message] = "Imported #{@items.count} items"

  rescue => e
    flash[:error] = "Error importing: #{e}"
    Rails.logger.warn("!!! Error importing CSV: #{e}")
    Rails.logger.warn(e.backtrace.join("\n"))
  ensure
    redirect_to '/'
  end

  # GET /items/random
  # GET /items/random.json
  def random
    @item = Item.offset(rand(Item.count)).first

    respond_to do |format|
      format.html { redirect_to @item }
      format.json { render json: @item }
    end
  end

  # GET /stats
  def stats
    @prices = Item.significant_prices
  end

  # GET /items/time_machine
  def time_machine
    @month_ago = Item.sorted.added_on_day 1.month.ago
    @six_months_ago = Item.sorted.added_on_day 6.months.ago
    @year_ago = Item.sorted.added_on_day 1.year.ago
  end

  # GET /items/words_for_field
  def words_for_field
    render json: Item.words_for_field(params[:field]).map{ |k,v| {text: k, weight: v} if v > 1 }.compact
  end

  private

  def authorize_item
    authorize Item
  end

  def expire_pages
    expire_page :controller => :items, :action => :stats
    expire_page :controller => :items, :action => :counts_by_day
    expire_page :controller => :items, :action => :words_for_field
  end

  def edit_discogs_param
    params[:sort] = 'discogs_url' if params[:sort] == 'discogs'
    if params[:item]
      params[:item][:discogs_url] ||= params[:item][:discogs]
    end
  end
end
