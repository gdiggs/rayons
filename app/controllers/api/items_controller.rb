module Api
  class ItemsController < BaseController
    def show
      render json: {sup: true}
    end
  end
end
