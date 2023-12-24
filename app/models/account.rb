class Account < ApplicationRecord
    devise :database_authenticatable, :registerable
    validates :first_name, :last_name, :email, :phone_number, presence: true

    validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0.0 }

    enum status: {
      unverified: -1,
      pending: 0,
      verified: 1
    }, _suffix: true

    has_many :transactions, foreign_key: 'sender_id'
    has_many :inbound_transactions, class_name: 'Transaction', foreign_key: 'receiver_id'

    normalizes :email, with: -> email { Formatters::EmailFormatter.new(email).perform }
    normalizes :phone_number, with: -> phone_number { Formatters::PhoneNumberFormatter.new(phone_number).perform }
    # before_save :normalize_email, if: :email_changed?
    # before_save :normalize_phone_number, if: :phone_number_changed?

  # private

  #   def normalize_email
  #     self.email = Formatters::EmailFormatter.new(self.email).perform
  #   end
  
  #   def normalize_phone_number
  #     self.phone_number = Formatters::PhoneNumberFormatter.new(self.phone_number).perform
  #   end
end
