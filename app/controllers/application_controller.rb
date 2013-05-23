class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :default_error_response

  def default_error_response(format, action, obj)
    format.html { render action: action }
    format.json { render json: obj.errors.full_messages, status: :unprocessable_entity }
  end

  rescue_from CanCan::AccessDenied do |exception|
    raise ActionController::RoutingError.new('Not Found')
  end
end
