module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from Exception do |exception|
      render json: { erros: I18n.t('errors.unexpecting_error') }, status: 500
    end
  end
end