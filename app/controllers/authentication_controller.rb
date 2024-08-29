class AuthenticationController < ApplicationController

  skip_before_action :authenticate_request, only: [:register, :login]
    # Register a new user
    def register
      @user = User.new(user_params)
      if @user.save
        render json: @user, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end
  
    # Log in a user and return a session token
    def login
      @user = User.find_by(email: params[:email])
      if @user&.authenticate(params[:password])
        # Generate a session token (you might want to use a gem like Devise for this)
        token = SecureRandom.hex(10)
        @user.update(token: token)
        render json: { token: token }, status: :ok

        if @user.update_column(:token, token)
            Rails.logger.debug "Token successfully saved: #{token}"
          else
            Rails.logger.debug "Failed to save token"
          end
          

      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
  end
  