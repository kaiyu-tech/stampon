# frozen_string_literal: true

module SessionsHelper
  include ActionController::HttpAuthentication::Token::ControllerMethods

  def connect(id)
    session[:user_id] = id
  end

  def current_user
    session[:user_id]
  end

  def disconnect
    User.find(session[:user_id]).update!(expires_at: nil) if connected?
    session.destroy
  end

  def authentication_required
    connected? || authenticate || respond_unauthorized
  end

  private

  def stampon_api_token
    ENV['STAMPON_API_TOKEN']
  end

  def connected?
    user = User.find_by(id: session[:user_id])
    user.present? && user.expires_at > Time.current
  end

  def authenticate
    action_name == 'create' &&
      authenticate_with_http_token do |token, _options|
        ActiveSupport::SecurityUtils.secure_compare(token, stampon_api_token)
      end
  end

  def respond_unauthorized
    respond_to do |format|
      format.html { redirect_to root_url, alert: 'access denied' }
      format.json { render json: { message: 'token invalid' }, status: :unauthorized }
    end
  end
end
