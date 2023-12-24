Rails.application.routes.draw do
  devise_for :accounts
  api_version(module: 'V1', path: { value: '/v1'}) do
    post '/login', to: 'authentication#login'

    resources :accounts, only: [] do
      collection do
        get :search
      end
    end

    resources :transactions, only: [:index, :create]
  end
end