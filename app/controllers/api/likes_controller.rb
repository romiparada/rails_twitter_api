# frozen_string_literal: true

module Api
  class LikesController < ApplicationController
    def create
      tweet = Tweet.find(params[:tweet_id])
      current_user.tweets_liked << tweet
      render status: :no_content
    end
  end
end
