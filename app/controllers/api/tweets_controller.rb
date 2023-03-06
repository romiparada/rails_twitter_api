# frozen_string_literal: true

module Api
  class TweetsController < ApplicationController
    def create
      tweet = current_user.tweets.create!(tweets_params)
      render json: TweetSerializer.render(tweet), status: :created
    end

    private

    def tweets_params
      params.require(:tweet).permit(%i[content])
    end
  end
end
