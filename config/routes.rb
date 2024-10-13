Rails.application.routes.draw do
  get 'feed/index'
  devise_for :users

  resources :posts do
    resources :comments, only: [:create, :destroy]
  end

  resources :users, only: [:show, :index] do
    member do
      post 'follow'
      delete 'unfollow'
    end
  end

  root 'posts#index'
  get 'feed', to: 'feed#index'
end
