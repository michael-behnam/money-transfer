module Payments
  class MoneyTransfer
    attr_reader :sender, :receiver, :amount

    def initialize(sender, receiver, amount)
      @sender = sender
      @receiver = receiver
      @amount = amount
    end

    def perform
      transfer_money_query_template = <<-SQL.squish
        UPDATE accounts 
          set balance = balance - %{amount}
          where accounts.id = %{sender_id};
        UPDATE accounts 
          set balance = balance + %{amount}
          where accounts.id = %{receiver_id};
      SQL

      transaction = nil

      ActiveRecord::Base.transaction do
        ActiveRecord::Base.connection.execute(
          transfer_money_query_template % {
            sender_id: sender.id,
            receiver_id: receiver.id,
            amount: amount
          }
        )

        transaction = Transaction.create!(
          sender_id: sender.id,
          receiver_id: receiver.id,
          amount: amount
        )
      end

      transaction
    end
  end
end
