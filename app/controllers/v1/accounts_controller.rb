class V1::AccountsController < ApplicationController
  def search
    # search by email or phone number
    # normalize search query before search
    # format phone number in search query to in the international format
    account_search_service = Accounts::Search.call(params[:identifier])

    if account_search_service.success?
      render json: AccountSerializer.new(account_search_service.result).serializable_hash, status: :ok
    else
      render json: { errors: account_search_service.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
