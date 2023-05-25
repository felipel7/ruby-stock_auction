Rails.application.routes.draw do
  devise_for :users
  root to: "lots#index"
  get "search", to: "lots#search", as: :search

  resources :favorites, only: [:index, :create]

  resources :bids, only: [:index, :new, :create]
  resources :categories, only: [:index, :new, :create, :edit, :update]
  resources :products, only: [:index, :show]
  resources :lots, only: [:index, :show]
  namespace :admin do
    resources :products, only: [:index, :show, :new, :create, :edit, :update]
    resources :lots, only: [:index, :show, :new, :create, :edit, :update] do
      member do
        get :manage
        post :add_product
        post :remove_product
        post :approved
        post :ended
      end
    end
    resources :profiles, only: [:index] do
      member do
        post :block
        post :unblock
      end
    end
  end
end
