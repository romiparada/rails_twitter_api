# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: 'api/users/', defaults: { format: :json }, controllers: {
    sessions: 'api/users/sessions',
    registrations: 'api/users/registrations',
    passwords: 'api/users/passwords'
  }

  scope '/api', module: :api, defaults: { format: :json } do
    resource :user, only: %i[show update]
    resources :tweets, only: %i[create show] do
      post :like, on: :member
    end

    scope '/users/:username', as: 'user', username: %r{[^/]+} do
      resources :tweets, only: :index
    end
  end
end
