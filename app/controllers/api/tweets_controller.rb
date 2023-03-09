# frozen_string_literal: true

module Api
  class TweetsController < ApplicationController
    def index
      render json: TweetSerializer.render(user.tweets.order(created_at: :desc))
    end

    def show
      render json: TweetSerializer.render(tweet)
    end

    def create
      tweet = current_user.tweets.create!(tweets_params)
      render json: TweetSerializer.render(tweet), status: :created
    end

    def like
      current_user.tweets_liked << tweet
      render status: :no_content
    end

    private

    def tweets_params
      params.require(:tweet).permit(%i[content])
    end

    def user
      User.find_by!(username: params[:user_username])
    end

    def tweet
      Tweet.find(params[:id])
    end
  end
end
