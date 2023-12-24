class V1::TransactionsController < ApplicationController
  def index
    if params[:type] == 'inbound'
      transations = @current_user.inbound_transactions
    else
      transations = @current_user.transactions
    end

    transactions = transations.page(params[:page] || 1)

    render json: TransactionSerializer.new(transactions).serializable_hash, status: :ok
  end

  def create
    receiver = Account.find_by_id(params[:transactions][:receiver_id])

    transaction_creator = Transactions::TransactionCreator.call(@current_user, 
                                                                receiver,
                                                                params[:transactions][:amount])

    if transaction_creator.success?
      render json: TransactionSerializer.new(transaction_creator.result).serializable_hash, status: :created
    else
      if transaction_creator.errors.added?(:sender, :unverified_account) || 
         transaction_creator.errors.added?(:receiver, :unverified_account)
        # unverified account
        status = :forbidden # 403
      else
        # wrong data
        status = :unprocessable_entity
      end

      render json: { errors: transaction_creator.errors.full_messages }, status: status
    end
  end
end
