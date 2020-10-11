class ApplicationController < ActionController::API
  before_action :validate_auth

  def validate_auth
    handle_unauthorized unless AuthValidationService.new(request.headers['Authorization']).valid_token?
  end

  def handle_unauthorized
    render json: {status: :unauthorized}, status: 401
  end

  def current_user
    CurrentUserService.new(request).current_user
  end
end
