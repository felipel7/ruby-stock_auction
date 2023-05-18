Rails.application.routes.draw do
  devise_for :users
  root to: "lots#index"
  get "search", to: "lots#search", as: :search

  resources :favorites, only: [:index, :create]
  resources :profiles, only: [:index] do
    member do
      post :block
      post :unblock
    end
  end
  resources :bids, only: [:index, :new, :create]
  resources :product_models, only: [:index, :show, :new, :create]
  resources :categories, only: [:index, :new, :create, :edit, :update]
  resources :lots, only: [:index, :show, :new, :create, :edit, :update] do
    member do
      get :manage
      post :add_product
      post :remove_product
      post :approved
      post :ended
    end
  end
end
