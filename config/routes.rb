Rails.application.routes.draw do
  root to: 'home#index'

  namespace :api do
    resources :products, only: [:index, :create, :destroy]
  end

  match '*path', to: 'home#index', via: :all
end
