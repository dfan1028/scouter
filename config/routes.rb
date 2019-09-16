Rails.application.routes.draw do
  root to: 'home#index'

  namespace :api, default: { format: 'json' } do
    resources :products, only: [:index, :create, :destroy]
  end

  match '*path', to: 'home#index', via: :all
end
