class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user
  private

  def authenticate_request
    token = request.headers['Authorization']
    Rails.logger.debug "Token received: #{token}"
    @current_user = User.find_by(token: token)
    if @current_user
      Rails.logger.debug "User found: #{@current_user.email}"
    else
      Rails.logger.debug "User not found"
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
