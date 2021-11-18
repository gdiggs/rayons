class ItemsController < ApplicationController
  include ApplicationHelper
  include ActionController::Live

  before_action :authenticate_user!
  before_action :authorize_item, only: [:new, :edit, :create, :update, :import, :destroy, :show]
  before_action :edit_discogs_param, only: [:index, :create, :update]
  before_action :set_variant, only: [:show]

  # GET /
  # GET /items
  # GET /items.json
  # GET /items.csv
  def index
    respond_to do |format|
      format.html do
        @can_edit = policy(Item).edit?
        @presenter = index_presenter
      end
      format.json { render json: index_presenter.as_json }
      format.csv { index_csv }
    end
  end

  # GET /items/discover
  def discover
    base_cache_key = ["discover", Item.unscoped.maximum(:updated_at).to_i].join("/")
    @genres = Rails.cache.fetch("#{base_cache_key}/genres") { [nil] + Item.all_genres }
    @styles = Rails.cache.fetch("#{base_cache_key}/styles") { [nil] + Item.all_styles }
    @formats = [nil] + ItemSearchPresenter.new.formats

    if params[:q]
      @item = ItemDiscoverPresenter.new(params[:q]).item

      if @item
        redirect_to @item, only_path: true
      else
        flash.now[:error] = "No item found. Try again!"
      end
    end
  end

  # GET /items/latest.json
  def latest
    number_of_items = params[:num].to_i
    number_of_items = 5 if number_of_items.zero?
    @items = Item.order("created_at DESC").limit(number_of_items)
    render json: @items
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html do
        render html: (cache [@item, request.variant, "2"] do
          @release = DiscogsRelease.new(@item)
          render_to_string
        end)
      end
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
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: "Item was successfully created." }
        format.json { render json: @item, status: :created, location: @item }
      else
        default_error_response(format, "new", @item)
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = Item.find(params[:id])
    params[:item] = params[:item].reject { |k, _| !Item.column_names.include?(k) }

    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: "Item was successfully updated." }
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

  # GET /items/import
  # POST /items/import
  def import
    if request.post?
      @items, @errors = ItemImporter.new(params[:urls].split).import
    end
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

  # GET /items/daily.json
  # Used for Alexa Flash Briefing Skill
  def daily
    @item = ItemOfTheDay.new

    render json: @item
  end

  private

  def authorize_item
    authorize Item
  end

  def edit_discogs_param
    params[:sort] = "discogs_url" if params[:sort] == "discogs"
    if params[:item]
      params[:item][:discogs_url] ||= params[:item][:discogs]
    end
  end

  def item_params
    params.require(:item).permit(:artist, :condition, :format, :label, :price_paid, :title, :year, :color, :notes, :discogs_url, genres: [], styles: [])
  end

  def set_variant
    request.variant = :editable if policy(:item).update?
  end

  def index_presenter
    ItemJSONPresenter.new(params.slice(:sort, :direction, :search, :page))
  end

  def index_csv
    set_streaming_headers
    headers.merge!("Content-Type" => "text/csv",
                   "Content-disposition" => "attachment; filename=\"rayons_#{Time.now.to_i}.csv\"")
    Item.to_csv { |row| response.stream.write row }
    response.stream.close
  end
end
