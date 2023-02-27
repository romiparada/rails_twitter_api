# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    def show
      render json: UserSerializer.render(current_user)
    end
  end
end
