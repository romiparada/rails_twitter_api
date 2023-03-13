# frozen_string_literal: true

module Api
  module Users
    class TweetsController < ApplicationController
      def index
        render json: TweetSerializer.render(user.tweets.order(created_at: :desc))
      end

      private

      def user
        User.find_by!(username: params[:user_username])
      end
    end
  end
end
