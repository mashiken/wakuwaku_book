# frozen_string_literal: true

Rails.application.routes.draw do
  get 'book_shelves/create'
  get 'book_shelves/destroy'
  get 'recommended_books/index'
  get 'recommended_books/create'
  get 'recommended_books/finish'
  get 'recommended_books/destroy'
  get 'users/index'
  get 'users/show'
  get 'users/edit'
  get 'users/update'
  get 'users/confirm'
  get 'users/hide'
  get 'favorites/create'
  get 'favorites/destroy'
  get 'reviews/index'
  get 'reviews/create'
  get 'reviews/destroy'
  get 'books/index'
  get 'books/show'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
