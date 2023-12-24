class AuthToken
  class << self
    def encode(payload)
      JWT.encode(payload, Rails.application.credentials.auth[:jwt_secret])
    end

    def decode(token)
      HashWithIndifferentAccess.new(JWT.decode(token, Rails.application.credentials.auth[:jwt_secret])[0])
    rescue => e
      ExceptionLogger.error(e)
      nil
    end
  end
end
