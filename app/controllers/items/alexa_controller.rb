class Items::AlexaController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_alexa

  def random
    presenter = ItemAlexaPresenter.new(params)

    render json: presenter
  end

  private

  def verify_alexa
    unless AlexaVerifier.valid?(request)
      render body: nil, status: :bad_request
    end
  end
end
