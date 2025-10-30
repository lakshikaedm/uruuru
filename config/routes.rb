Rails.application.routes.draw do
  resources :products
  devise_for :users,
             controllers: {
               sessions: "users/sessions"
             }
  resources :categories, only: %i[show index]

  resources :products, only: %i[index show] do
    resource :favorite, only: %i[create destroy], controller: 'favorites'
  end
  resources :favorites, only: [:index]

  resource :profile, only: :show, controller: "users"

  resource :cart, only: :show

  resource :cart_item, only: [] do
    post ":product_id", to: "cart_items#create", as: :create
    patch ":product_id", to: "cart_items#update", as: :update
    delete ":product_id", to: "cart_items#destroy", as: :destroy
  end

  resources :orders, only: %i[new create show]

  root "products#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
