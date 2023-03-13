# frozen_string_literal: true

module Api
  class UserController < ApplicationController
    skip_before_action :user_profile_filled, only: %i[show update]

    def show
      render json: UserSerializer.render(current_user, view: :full)
    end

    def update
      current_user.update!(user_params)
      render json: UserSerializer.render(current_user, view: :full)
    end

    private

    def user_params
      params.require(:user).permit(%i[name bio website email birthdate password username profile_image])
    end
  end
end
