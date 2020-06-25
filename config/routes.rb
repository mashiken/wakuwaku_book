# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#top'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #本棚routes
  resources :book_shelves, only: [:create, :destroy]
  #書籍検索/詳細routes
  resources :books, only: [:index,:show]
  #書籍レビューroutes/いいねroutesネスト
  resources :reviews, only: [:index,:create,:edit, :update, :destroy] do
    resource :favorites, only: [:create,:destroy]
  end
  #オススメ書籍routes
  resources :recommended_books, only: [:index,:create,:destroy] do
    get :finish, on: :collection
  end
  #ユザーroutes
  resources :users, only: [:index,:show,:edit,:update] do
    get :confirm, on: :collection
    put :hide, on: :collection
  end
end
