Rails.application.routes.draw do
  devise_for :users
  root to: "lots#index"

  resources :bids, only: [:index, :new, :create]
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
