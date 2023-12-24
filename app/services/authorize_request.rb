class AuthorizeRequest
  prepend SimpleCommand

  attr_reader :headers

  def initialize(headers)
    @headers = headers
  end

  def call
    Authenticator.find_user(authorization_token)
  end

  private

  # extracting authorization token
  def authorization_token
    pattern = /^Bearer /
    auth_header  = headers['Authorization']
    auth_header.gsub(pattern, '') if auth_header && auth_header.match(pattern)
  end
end
