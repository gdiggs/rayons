class Items::AlexaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def random
    presenter = ItemAlexaPresenter.new(params)

    render json: presenter
  end
end
