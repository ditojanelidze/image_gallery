class AuthValidationService < ApplicationService
  def initialize(token)
    @token = token
  end

  def valid_token?
    decoded_data = Jwt::TokenDecoderService.new(@token).decode
    decoded_data[:valid] == true
  end
end