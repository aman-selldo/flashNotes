class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  SECRET_KEY = Rails.application.secret_key_base


  def authenticate_request
    header = request.headers["Authorization"]
    if header
      token = header.split(" ").last
      begin
        decoded = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')[0]
        @current_user = User.find(decoded["user_id"])
      rescue JWT::DecodeError
        render json: {error: "Invalid token"}, status: :unauthorized
      end
    else
      render json: {error: "Token missing" }, status: :unauthorized
    end
  end


  def current_user
    @current_user
  end

end
