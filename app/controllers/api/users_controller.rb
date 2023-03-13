# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    def follow
      current_user.following_users << user
      render status: :no_content
    end

    def unfollow
      current_user.following_users.find(user.id).destroy!
      render status: :no_content
    end

    def followers
      render json: UserSerializer.render(user.follower_users, view: :full)
    end

    private

    def user
      User.find_by!(username: params[:username])
    end
  end
end
