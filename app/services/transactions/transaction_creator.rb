module Transactions
  class TransactionCreator
    prepend SimpleCommand
    include ActiveModel::Validations
    attr_reader :sender, :receiver, :amount

    validates_presence_of :sender, :receiver, :amount
    validates :amount, presence: true, numericality: { greater_than: 0.0 }

    # make sure the sender account is verified and have enough money
    validates_with SendingMoneyValidator
    # make sure the receiver account is verified
    validates_with ReceivingMoneyValidator

    def initialize(sender, receiver, amount)
      @sender = sender
      @receiver = receiver
      @amount = amount
    end

    def call
      return unless valid?

      # transfer money and create a transaction
      Payments::MoneyTransfer.new(sender, receiver, amount).perform
    rescue => e
      errors.add(:base, :failed_transaction)
    end
  end
end
