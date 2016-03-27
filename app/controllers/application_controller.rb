class ApplicationController < ActionController::Base
  include Pundit
  include CacheableFlash

  protect_from_forgery with: :exception

  force_ssl except: [:status], if: proc { Rails.env.production? }

  helper_method :default_error_response

  def blitz
    render text: 42
  end

  def default_error_response(format, action, obj)
    format.html { render action: action }
    format.json { render json: obj.errors.full_messages, status: :unprocessable_entity }
  end

  def opensearch
    render "/opensearch.xml", layout: false
  end

  def status
    render json: {
      ok: true,
      revision: Rails.configuration.git_revision,
    }
  end

  def render_403
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/403", layout: false, status: :forbidden }
      format.xml { head :forbidden }
      format.any { head :forbidden }
    end
  end

  rescue_from Pundit::NotAuthorizedError, with: :render_403
end
