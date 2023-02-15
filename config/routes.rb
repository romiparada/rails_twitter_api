# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    devise_for :users, module: 'api/users', defaults: { format: :json }
  end
end
