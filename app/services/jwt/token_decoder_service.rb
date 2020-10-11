module Jwt
  class TokenDecoderService < ApplicationService
    def initialize(token)
      @token = token
    end

    def decode
      result = JWT.decode(bearer_token, secret_key, true, {algorithm: 'HS256'})[0]
      {valid: true}.merge(result)
    rescue
      {valid: false}
    end

    private

    def bearer_token
      pattern = /^Bearer /
      @token.gsub(pattern, '') if @token&.match(pattern)
    end

    def secret_key
      Rails.application.credentials.jwt_secret_key
    end
  end
end