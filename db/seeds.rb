# frozen_string_literal: true

return if Account.exists?

initial_accounts = [
  {
    first_name: 'Michael',
    last_name: 'Sender',
    phone_number: '+9711111111',
    email: 'michael.sender@test.test',
    status: :verified,
    balance: 10000.0,
    password: 'Test123456789'
  },
  {
    first_name: 'Michael',
    last_name: 'Receiver',
    phone_number: '+9712222222',
    email: 'michael.reciever@test.test',
    status: :verified,
    balance: 10000.0,
    password: 'Test123456789'
  },
  {
    first_name: 'Michael',
    last_name: 'Unverified',
    phone_number: '+9712222222',
    email: 'michael.unverified@test.test',
    status: :unverified,
    balance: 10000.0,
    password: 'Test123456789'
  }
]

Account.create(initial_accounts)
