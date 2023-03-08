# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    skip_before_action :user_profile_filled, only: %i[show update]

    def show
      render json: UserSerializer.render(current_user, view: :full)
    end

    def update
      current_user.update!(user_params)
      render json: UserSerializer.render(current_user, view: :full)
    end

    def follow
      current_user.following_users << user
      render status: :no_content
    end

    def unfollow
      user.follower_users.find(current_user.id)
      user.follower_users.destroy(current_user)
      render status: :no_content
    end

    private

    def user_params
      params.require(:user).permit(%i[name bio website email birthdate password username])
    end

    def user
      User.find_by!(username: params[:username])
    end
  end
end
