Rails.application.routes.draw do
devise_for :users
  root 'home#top'
  get 'home/about'
  get '/search' => 'search#search' ,as: 'search'
  resources :users,only: [:show,:index,:edit,:update] do
  		member do
  			get :following, :followers
  		end
  end
  resources :books do
  	resource :post_comments, only: [:create,:destroy]
  	resource :favorites, only: [:create, :destroy]
  end

  resources :relationships,       only: [:create, :destroy]

  # 通知用
  resources :notifications, only: :index


end