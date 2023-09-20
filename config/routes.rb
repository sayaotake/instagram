Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:show] # ユーザーマイページへのルーティング
  get 'tweets/top'=> 'tweets#top'
  resources :tweets do
  resources :likes, only: [:create, :destroy]
  resources :comments, only: [:create]
  end
  
  root 'tweets#top'

end
