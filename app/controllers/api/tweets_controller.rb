# frozen_string_literal: true

module Api
  class TweetsController < ApplicationController
    def create
      tweet = Tweet.create!(tweets_params.merge({ user: current_user }))
      render json: TweetSerializer.render(tweet), status: :created
    end

    private

    def tweets_params
      params.require(:tweet).permit(%i[content])
    end
  end
end
