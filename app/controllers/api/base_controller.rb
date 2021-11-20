module Api
  class BaseController < ApplicationController
    before_action :authenticate_token

    private

    def authenticate_token
      authenticate_or_request_with_http_token do |token, _options|
        api_token = ApiToken.find_by!(token: token)
        if ActiveSupport::SecurityUtils.secure_compare(token, api_token.token)
          api_token.user
        end
      end
    end
  end
end
