class RefreshTokenService < ApplicationService
  def initialize(refresh_params)
    super()
    @refresh_params = refresh_params
  end

  def json_view
    {access_token: @access_token, refresh_token: @refresh_token}
  end

  def refresh
    storage_service = Jwt::RefreshTokenStorageService.new(@refresh_params[:refresh_token])
    @user_id = storage_service.find
    if @user_id.present?
      @access_token, @refresh_token = Jwt::TokenProviderService.new(payload).generate_tokens
      storage_service.delete
    else
      fill_errors(:base, :unauthorized, "invalid_refresh_token")
    end
  end

  def payload
    {user_id: @user_id, exp: (DateTime.now + JWT_TOKEN_LIFETIME.minutes).to_i}
  end
end