Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root to: "home#index"

  resources :product_models, only: [:index, :show, :new, :create]
  resources :categories, only: [:index, :new, :create, :edit, :update]
  resources :lots, only: [:index, :show, :new, :create, :edit, :update] do
    member do
      get :manage
      post :add_product
      post :remove_product
      post :approved
    end
  end
end
