require 'rails_helper'

RSpec.describe "V1::Accounts", type: :request do
  before(:all) do
    @account = create(:account)
  end

  describe "GET /search" do
    context 'Find by email' do
      it 'returns the account' do
        get '/v1/accounts/search',
            params: {
              identifier: @account.email,
            },
            headers: authenticated_header(@account)
  
        response_json = JSON.parse(response.body)

        expect(response_json['data']['id'].to_i).to eq(@account.id)
        expect(response_json['data']['attributes']['email']).to eq(@account.email)
      end

      it 'ignores case' do
        get '/v1/accounts/search',
            params: {
              identifier: @account.email.upcase,
            },
            headers: authenticated_header(@account)
  
        response_json = JSON.parse(response.body)

        expect(response_json['data']['id'].to_i).to eq(@account.id)
        expect(response_json['data']['attributes']['email']).to eq(@account.email)
      end
    end

    context 'Find by phone' do
      it 'returns the account' do
        get '/v1/accounts/search',
            params: {
              identifier: @account.phone_number,
            },
            headers: authenticated_header(@account)
  
        response_json = JSON.parse(response.body)

        expect(response_json['data']['id'].to_i).to eq(@account.id)
        expect(response_json['data']['attributes']['phone_number']).to eq(@account.phone_number)
      end

      it 'normalize the phone number' do
        get '/v1/accounts/search',
            params: {
              identifier: TelephoneNumber.parse(@account.phone_number, :ua).national_number,
            },
            headers: authenticated_header(@account)
  
        response_json = JSON.parse(response.body)

        expect(response_json['data']['id'].to_i).to eq(@account.id)
        expect(response_json['data']['attributes']['phone_number']).to eq(@account.phone_number)
      end
    end
  end
end
