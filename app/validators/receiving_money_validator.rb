class ReceivingMoneyValidator < ActiveModel::Validator
  def validate(record)
    return if record.receiver.blank?

    unless record.receiver.verified_status?
      record.errors.add :receiver, :unverified_account
    end
  end
end
