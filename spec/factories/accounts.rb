FactoryBot.define do
  factory :account do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.cell_phone_in_e164 }
    balance { 1000 }


    status { 'pending' }

    trait :verified do
      status { 'verified' }
    end
  end
end
