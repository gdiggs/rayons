class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery
  before_filter :check_responsive

  helper_method :default_error_response

  def blitz
    render :text => 42
  end

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

  def opensearch
    render '/opensearch.xml', :layout => false
  end

  def render_403
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/403", :layout => false, :status => :forbidden }
      format.xml  { head :forbidden }
      format.any  { head :forbidden }
    end
  end

  rescue_from Pundit::NotAuthorizedError, with: :render_403

end
