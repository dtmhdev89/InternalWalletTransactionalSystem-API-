Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  scope "api/v1", module: "api/v1" do
    post :login, to: "sessions#create"
    delete :logout, to: "sessions#destroy"

    resources :users, only: [] do
      resources :wallets, only: %i[index], module: :users
    end

    resources :wallets, only: [] do
      resource :balances, only: %i[show], module: :wallets
      resources :deposits, only: %i[create], module: :wallets
      resource :transaction_statuses, only: %i[show], module: :wallets
      resources :transfers, only: %i[create], module: :wallets
      resources :withdrawals, only: %i[create], module: :wallets
    end
  end
end
