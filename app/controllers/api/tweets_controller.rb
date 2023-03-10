# frozen_string_literal: true

module Api
  class TweetsController < ApplicationController
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

    def feed
      feed = Tweet.authored_by(current_user.following_users)
                  .or(Tweet.liked_by(current_user.following_users)
                            .where.not(user: current_user))
                  .order(created_at: :desc)
      render json: TweetSerializer.render(feed)
    end

    private

    def tweets_params
      params.require(:tweet).permit(%i[content])
    end

    def tweet
      Tweet.find(params[:id])
    end
  end
end
