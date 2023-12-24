module Accounts
  class Search
    prepend SimpleCommand
    include ActiveModel::Validations

    attr_reader :identifier

    validates_presence_of :identifier

    def initialize(identifier)
      @identifier = identifier
    end

    def call
      return unless valid?

      Account.where(email: normalized_email).or(
        Account.where(phone_number: normalized_phone_number)
      ).first
    end

    private

    def normalized_email
      Formatters::EmailFormatter.new(identifier).perform
    end

    def normalized_phone_number
      Formatters::PhoneNumberFormatter.new(identifier).perform
    end
  end
end