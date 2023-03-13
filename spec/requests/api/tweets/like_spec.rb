# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/tweets/:id/like', type: :request do
  subject { post like_tweet_path(id), headers:, as: :json }

  let(:user) { create(:user) }
  let(:headers) { auth_headers(user) }
  let(:tweet) { create(:tweet) }
  let(:id) { tweet.id }

  context 'when the params are correct' do
    context 'when the user likes others tweet' do
      it 'returns 204 status code' do
        subject
        expect(response).to have_http_status(:no_content)
      end

      it 'associates user and tweet' do
        subject
        expect(tweet.reload.liked_by).to include(user)
        expect(user.reload.tweets_liked).to include(tweet)
      end
    end

    context 'when the user likes his own tweet' do
      let(:tweet) { create(:tweet, user:) }

      it 'returns 422 status code' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the correct error message' do
        subject
        expect(errors['user']).to eq(["can't like his own tweet"])
      end
    end
  end

  context 'when the params are incorrect' do
    context 'when the tweet id is invalid' do
      let(:id) { 'invalid' }

      it 'returns 404 status code' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the auth header is not set' do
      let(:headers) { {} }

      it 'returns 401 status code' do
        subject
        expect(response).to have_http_status(401)
      end
    end
  end
end
