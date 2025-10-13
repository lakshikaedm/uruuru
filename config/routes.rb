Rails.application.routes.draw do
  devise_for :users

  resources :categories, only: %i[index show]

  resources :products, only: %i[index show create new edit update destroy] do
    resource :favorite, only: %i[create destroy]
  end

  root "products#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
