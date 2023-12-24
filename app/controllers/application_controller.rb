class ApplicationController < ActionController::API
  before_action :authenticate_account
  attr_reader :current_user

  include ExceptionHandler

  private

  def authenticate_account
    # authenticating and getting current user
    @current_user = AuthorizeRequest.call(request.headers).result

    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end
end
