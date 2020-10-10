class AuthController < ApplicationController
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
end