Rails.application.routes.draw do
  resources :products
  devise_for :users
  resources :categories, only: %i[show index]

  root "products#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
