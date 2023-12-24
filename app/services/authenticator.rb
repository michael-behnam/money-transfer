class Authenticator
  class << self
    TOKEN_VALIDITY = 1.day

    def generate_token payload
      payload[:issued_at] = Time.now
      AuthToken.encode(payload)
    end

    # find user and consider rules for expiring login
    def find_user(token)
      return nil if token.blank?

      auth_data = AuthToken.decode(token)

      return nil if auth_data.blank? || auth_data[:issued_at] < Time.now - TOKEN_VALIDITY

      Account.find_by_id(auth_data[:account_id])
    end
  end
end
