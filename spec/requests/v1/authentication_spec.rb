require 'rails_helper'

RSpec.describe "V1::Authentications", type: :request do
  before(:all) do
    @password = 'Test123456789'
    @account = create(:account, password: @password)
  end

  describe "GET /login" do
    it 'logins successfully' do
      post '/v1/login',
          params: {
            accounts: {
              email: @account.email,
              password: @password
            }
          },
          headers: authenticated_header(@account)

      response_json = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(response_json['data']['token'].to_i).not_to be_blank
    end

    it 'dosesnot accept wrong credentials' do
      post '/v1/login',
          params: {
            accounts: {
              email: @account.email,
              password: "#{@password}test"
            }
          },
          headers: authenticated_header(@account)

      response_json = JSON.parse(response.body)

      expect(response).not_to have_http_status(:success)
      expect(response_json['errors']).not_to be_blank
    end
  end
end
