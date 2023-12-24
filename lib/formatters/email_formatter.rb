module Formatters
  class EmailFormatter
    attr_reader :email

    def initialize(email)
      @email = email
    end

    def perform
      return nil if email.blank?

      email.strip.downcase
    end
  end
end
