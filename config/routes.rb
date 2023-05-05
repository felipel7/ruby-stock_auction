Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root to: "home#index"

  resources :product_models, only: [:index, :show, :new, :create]
  resources :lots, only: [:index, :show, :new, :create]
end
