class ApplicationController < ActionController::Base
  include CacheableFlash

  protect_from_forgery with: :exception

  helper_method :default_error_response

  def blitz
    render text: 42
  end

  def default_error_response(format, action, obj)
    format.html { render action: action }
    format.json { render json: obj.errors.full_messages, status: :unprocessable_entity }
  end

  def opensearch
    render "/opensearch", layout: false
  end

  def status
    render json: {
      ok: true,
      revision: Rails.configuration.git_revision,
    }
  end

  def render_403
    respond_to do |format|
      format.html { send_file "#{Rails.root}/public/403.html", status: :forbidden }
      format.xml { head :forbidden }
      format.any { head :forbidden }
    end
  end

  def authenticate_user!
    if current_user && current_user.admin?
      super
    else
      redirect_to new_user_session_path
    end
  end
end
