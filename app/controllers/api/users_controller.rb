# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    skip_before_action :user_profile_filled, only: :show

    def show
      render json: UserSerializer.render(current_user)
    end

    def update
      user = current_user
      if user.update(user_params)
        render json: UserSerializer.render(user)
      else
        render json: { errors: user.errors.messages }, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :bio, :website, :email, :birthdate, :password)
    end
  end
end
