require 'rails_helper'

RSpec.describe "V1::Transactions", type: :request do
  before(:all) do
    @verified_sender = create(:account, status: 'verified', balance: 10000)
    @verified_reciever = create(:account, status: 'verified')

    @unverified_account = create(:account, balance: 10000)

    @transaction = create(:transaction, sender: @verified_sender, receiver: @verified_reciever)
  end

  describe "POST /create - Transfer money" do
    context 'valid data' do
      it 'transfer money between accounts' do
        amount = 1000
        sender_balance = @verified_sender.reload.balance
        receiver_balance = @verified_reciever.reload.balance

        post '/v1/transactions',
          params: {
            transactions: {
              receiver_id: @verified_reciever.id,
              amount: amount
            }
          },
          headers: authenticated_header(@verified_sender)

        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:created)

        expect(@verified_sender.reload.balance).to eq(sender_balance - amount)
        expect(@verified_reciever.reload.balance).to eq(receiver_balance + amount)
      end
      
      it 'create a transaction' do
        amount = 1000.0

        expect do
          post '/v1/transactions',
            params: {
              transactions: {
                receiver_id: @verified_reciever.id,
                amount: amount
              }
            },
            headers: authenticated_header(@verified_sender)

          response_json = JSON.parse(response.body)

          expect(response).to have_http_status(:success)

          expect(response_json['data']['attributes']['amount'].to_f).to eq(amount)
          expect(response_json['data']['relationships']['sender']['data']['id'].to_i).to eq(@verified_sender.id)
          expect(response_json['data']['relationships']['receiver']['data']['id'].to_i).to eq(@verified_reciever.id)
        end.to change(Transaction, :count).by(1)
      end
    end

    context 'validations' do
      it 'doesnot accept unverified senders' do
        amount = 1000
        sender_balance = @unverified_account.reload.balance
        receiver_balance = @verified_reciever.reload.balance

        post '/v1/transactions',
          params: {
            transactions: {
              receiver_id: @verified_reciever.id,
              amount: amount
            }
          },
          headers: authenticated_header(@unverified_account)

        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:forbidden) #403

        expect(@unverified_account.reload.balance).to eq(sender_balance)
        expect(@verified_reciever.reload.balance).to eq(receiver_balance)
      end
   
      it 'doesnot accept unverified receivers' do
        amount = 1000
        sender_balance = @verified_sender.reload.balance
        receiver_balance = @unverified_account.reload.balance

        post '/v1/transactions',
          params: {
            transactions: {
              receiver_id: @unverified_account.id,
              amount: amount
            }
          },
          headers: authenticated_header(@verified_sender)

        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:forbidden) #403

        expect(@verified_sender.reload.balance).to eq(sender_balance)
        expect(@unverified_account.reload.balance).to eq(receiver_balance)
      end

      it 'doesnot accept zero amount transfers' do
        amount = 0
        sender_balance = @verified_sender.reload.balance
        receiver_balance = @verified_reciever.reload.balance

        post '/v1/transactions',
          params: {
            transactions: {
              receiver_id: @verified_reciever.id,
              amount: amount
            }
          },
          headers: authenticated_header(@verified_sender)

        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)

        expect(@verified_sender.reload.balance).to eq(sender_balance)
        expect(@verified_reciever.reload.balance).to eq(receiver_balance)
      end

      it 'doesnot accept negative amount transfers' do
        amount = -5
        sender_balance = @verified_sender.reload.balance
        receiver_balance = @verified_reciever.reload.balance

        post '/v1/transactions',
          params: {
            transactions: {
              receiver_id: @verified_reciever.id,
              amount: amount
            }
          },
          headers: authenticated_header(@verified_sender)

        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)

        expect(@verified_sender.reload.balance).to eq(sender_balance)
        expect(@verified_reciever.reload.balance).to eq(receiver_balance)
      end
    end
  end

  describe "List inbound transactions" do
    it 'lists inbound transactions' do
      get '/v1/transactions',
        headers: authenticated_header(@verified_sender)

      response_json = JSON.parse(response.body)

      expect(response_json['data']).to include(include('id' => @transaction.id.to_s))
    end
  end

  describe "List outbound transactions" do
    it 'lists inbound transactions' do
      get '/v1/transactions',
        params: {
          type: 'inbound',
        },
        headers: authenticated_header(@verified_reciever)

      response_json = JSON.parse(response.body)

      expect(response_json['data']).to include(include('id' => @transaction.id.to_s))
    end
  end
end
