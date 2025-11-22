Rails.application.routes.draw do
  resources :products
  devise_for :users,
             controllers: {
               sessions: "users/sessions",
               omniauth_callbacks: "users/omniauth_callbacks"
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

  resources :orders, only: %i[index new create show edit update] do
    member do
      post :pay
      get :success
      get :cancel
    end
  end

  resources :conversations, only: %i[index show create] do
    resources :messages, only: :create
  end

  get "postal_code", to: "postal_codes#show"

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  root "products#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
