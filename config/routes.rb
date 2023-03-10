# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: 'api/users/', defaults: { format: :json }, controllers: {
    sessions: 'api/users/sessions',
    registrations: 'api/users/registrations',
    passwords: 'api/users/passwords'
  }

  scope '/api', module: :api, defaults: { format: :json } do
    resource :user, only: %i[show update], controller: :user

    resources :tweets, only: %i[create show] do
      post :like, on: :member
    end

    resources :users, only: [], param: :username, username: %r{[^/]+} do
      post :follow, on: :member
      post :unfollow, on: :member
      get :followers, on: :member
      get :followings, on: :member
      resources :tweets, only: :index, module: :users
    end
  end
end
