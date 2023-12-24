class V1::AuthenticationController < ApplicationController
  skip_before_action :authenticate_account
 
  def login
    authentication_service = Authentication::Login.call(params[:accounts][:email],
                                                        params[:accounts][:password])

    if authentication_service.success?
      render json: { data: { token: authentication_service.result } }, status: :ok
    else
      render json: { errors: authentication_service.errors.full_messages }, status: :unauthorized
    end
  end
end
