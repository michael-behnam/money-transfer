class Transaction < ApplicationRecord
  belongs_to :sender, class_name: 'Account'
  belongs_to :receiver, class_name: 'Account'

  validates_presence_of :sender, :receiver, :amount
  validates :amount, presence: true, numericality: { greater_than: 0.0 }
end
