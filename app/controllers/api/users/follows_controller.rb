# frozen_string_literal: true

module Api
  module Users
    class FollowsController < ApplicationController
      def index
        list = if params[:followers]
                 user.follower_users
               else
                 user.follower_users + user.following_users
               end
        render json: UserSerializer.render(list, view: :full)
      end

      private

      def user
        User.find_by!(username: params[:user_username])
      end
    end
  end
end
