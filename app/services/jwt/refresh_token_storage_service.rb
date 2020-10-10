module Jwt
  class RefreshTokenStorageService
    def initialize(refresh_token, user_id)
      @refresh_token_key = "refresh_#{refresh_token}"
      @user_id = user_id
    end

    def store
      $redis.set @refresh_token_key, @user_id
      $redis.expire @refresh_token_key, expiration_time
    end

    def find
      $redis.get(@refresh_token_key)&.to_i
    end

    def refresh
      @redis.expire @refresh_token_key, expiration_time
    end

    def delete
      $redis.del @refresh_token_key
    end

    private

    def expiration_time
      REFRESH_TOKEN_LIFETIME * 60
    end
  end
end