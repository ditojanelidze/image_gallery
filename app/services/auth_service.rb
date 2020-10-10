class AuthService < ApplicationService
  @@jwt_token_lifetime

  def initialize(auth_params)
    super()
    @auth_params = auth_params
  end

  def json_view
    {access_token: @access_token, refresh_token: @refresh_token}
  end

  def auth
    @user = User.auth(*@auth_params.values)
    @user.present? ? generate_tokens : handle_unauthorized
  end

  private

  def generate_tokens
    @access_token, @refresh_token = Jwt::TokenProviderService.new(payload).generate_tokens
  end

  def handle_unauthorized
    fill_errors(:base, :unauthorized, custom_error_msg("unauthorized"))
  end

  def payload
    {user_id: @user.id, exp: (DateTime.now + JWT_TOKEN_LIFETIME.minutes).to_i}
  end
end