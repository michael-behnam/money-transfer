module Authentication
  class Login
    prepend SimpleCommand
    include ActiveModel::Validations

    attr_reader :email, :password

    validates_presence_of :email, :password

    def initialize(email, password)
      @email = email
      @password = password
    end

    def call
      return unless valid?

      account = Account.find_by_email(email)

      if account.blank? || !account.valid_password?(password)
        errors.add(:base, :invalid_credintials)
        return
      end

      payload = {
        account_id: account.id
      }

      # get auth token
      Authenticator.generate_token(payload)
    end
  end
end
