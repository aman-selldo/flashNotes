class AuthController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:login, :signup, :logout]

    SECRET_KEY = Rails.application.secret_key_base

    def signup
      user = User.new(user_params)
      if user.save
        token = generate_jwt(user)
        cookies.signed[:jwt] = {
          value: token,
          httpOnly: true,
          expires: 24.hours.from_now
      }
        respond_to do |format|
          format.html { render :signup, locals: {user: user, token: token} }
          format.json {render json: {token: token, user: user}, status: :ok}
        end
      else
        respond_to do |format|
          format.html   { render :signup, locals: { errors: user.errors.full_messages} }
          format.json {render json: {errors: user.errors.full_messages}, status: unprocessable_entity}
        end
      end
    end

    def login
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
            token = generate_jwt(user)
            cookies.signed[:jwt] = {
                value: token,
                httpOnly: true,
                expires: 24.hours.from_now
            }
            respond_to do |format|
                format.html { render :login, locals: {user: user, token: token}}
                format.json {render json: {token: token, user: {id: user.id, username: user.username, email: user.email, role: user.role}}, status: :ok}
            end
        else
            respond_to do |format|
                format.html { render :login, locals: {errors: user.errors.full_messages} }
                format.json {render json: {errors: "Invalid email or password"}, status: :unauthorized}
            end
        end
    end

    def logout
        cookies.delete(:jwt)
        respond_to do |format|
            format.html {redirect_to login_path , notice: "Logged out successfully"}
            format.json {render json: {message: "Logged out successfully"}, status: :ok}
        end
    end

    private

    def user_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end

    def generate_jwt(user)
        JWT.encode({user_id: user.id, role: user.role, exp: 24.hours.from_now.to_i}, SECRET_KEY, 'HS256')
    end
end