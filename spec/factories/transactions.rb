FactoryBot.define do
  factory :transaction do
    sender factory: :account
    receiver factory: :account
    amount { 1000 }
  end
end
