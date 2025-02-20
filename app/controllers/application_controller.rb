class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  SECRET_KEY = Rails.application.secret_key_base

  before_action :authenticate_request

  def authenticate_request
    cookie = cookies.signed[:jwt]
    if cookie
      begin
        decoded = JWT.decode(cookie, SECRET_KEY, true, algorithm: 'HS256')[0]
        @current_user = User.find(decoded["user_id"])
      rescue JWT::DecodeError
        render json: {error: "Invalid token"}, status: :unauthorized
      end
    else
      redirect_to login_path
    end
  end


  def current_user
    @current_user ||= authenticate_request
  end

  # def look_cookies
  #   redirect_to root_path if current_user.present? 
  #   return nil
  # end


  helper_method :current_user
end
