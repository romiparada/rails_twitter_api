# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    skip_before_action :user_profile_filled, only: %i[show update]

    def show
      render json: UserSerializer.render(current_user)
    end

    def update
      if current_user.update(user_params)
        render json: UserSerializer.render(current_user)
      else
        render json: { errors: current_user.errors.messages }, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(%i[name bio website email birthdate password username])
    end
  end
end
