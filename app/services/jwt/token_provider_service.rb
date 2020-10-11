module Jwt
  class TokenProviderService
    def initialize(payload)
      @payload = payload
    end

    def generate_tokens
      access_token = generate_access_token
      refresh_token = generate_refresh_token
      store_in_redis(refresh_token)
      [access_token, refresh_token]
    end

    def generate_access_token
      JWT.encode(@payload, secret_key, 'HS256', { typ: 'JWT' })
    end

    def generate_refresh_token
      SecureRandom.uuid
    end

    def store_in_redis(refresh_token)
      RefreshTokenStorageService.new(refresh_token, @payload[:user_id]).store
    end

    def secret_key
      Rails.application.credentials.jwt_secret_key
    end
  end
end