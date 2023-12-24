class TransactionSerializer
  include JSONAPI::Serializer
  attributes :amount

  belongs_to :sender, serializer: :account
  belongs_to :receiver, serializer: :account
end
