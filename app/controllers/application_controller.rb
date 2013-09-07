class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_responsive

  helper_method :default_error_response

  def check_responsive
    if params[:exclude_responsive]
      if params[:exclude_responsive] == 'false'
        cookies.delete(:exclude_responsive)
      else
        cookies[:exclude_responsive] = true
      end
    end
  end

  def default_error_response(format, action, obj)
    format.html { render action: action }
    format.json { render json: obj.errors.full_messages, status: :unprocessable_entity }
  end

  # This method is from http://stackoverflow.com/a/2385821
  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    raise ActionController::RoutingError.new('Not Found')
  end
end
