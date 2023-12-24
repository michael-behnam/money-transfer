class AccountSerializer
  include JSONAPI::Serializer
  attributes :first_name, :last_name, :email, :phone_number
end
