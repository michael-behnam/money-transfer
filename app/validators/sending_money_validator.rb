class SendingMoneyValidator < ActiveModel::Validator
  def validate(record)
    return if record.sender.blank?

    record.errors.add(:sender, :unverified_account) unless record.sender.verified_status?

    if record.sender.balance.to_f < record.amount.to_f
      record.errors.add(:sender, :money_is_not_enough)
    end
  end
end
