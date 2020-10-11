class CurrentUserService
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def current_user
    User.find(user_id)
  end

  private

  def user_id
    payload = Base64.decode64(token.split('.').second)
    JSON.parse(payload)['user_id']
  end

  def token
    auth_header_token.gsub(/^Bearer /, '')
  end

  def auth_header_token
    request.headers['Authorization']
  end
end