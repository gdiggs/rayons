module Api
  class ItemsController < BaseController
    def daily
      @item = ItemOfTheDay.new

      render json: @item
    end

    def random
      @item = Item.random

      render json: ItemBlueprint.render(@item)
    end

    def show
      @item = Item.find(params[:id])

      render json: ItemBlueprint.render(@item)
    end
  end
end
