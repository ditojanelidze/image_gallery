class AuthController < ApplicationController
  skip_before_action :validate_auth

  def auth
    service = AuthService.new(auth_params)
    service.auth
    render service.result
  end

  def refresh_token
    service = RefreshTokenService.new(refresh_token_params)
    service.refresh
    render service.result
  end

  private

  def auth_params
    params.permit(:username, :password)
  end

  def refresh_token_params
    params.permit(:refresh_token)
  end
end