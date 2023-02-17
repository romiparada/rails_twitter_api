# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    devise_for :users, defaults: { format: :json }, controllers: {
      sessions: 'api/users/sessions',
      registrations: 'api/users/registrations',
      passwords: 'api/users/passwords'
    }
  end
end
