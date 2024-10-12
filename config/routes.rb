Rails.application.routes.draw do
  get 'feed/index'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
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
