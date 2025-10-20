Rails.application.routes.draw do
  resources :products
  devise_for :users
  resources :categories, only: %i[show index]

  resources :products, only: [:index, :show] do
    resource :favorite, only: [:create, :destroy], controller: 'favorites'
  end
  resources :favorites, only: [:index]

  root "products#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
