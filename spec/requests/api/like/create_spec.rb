# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/tweets/[:tweet_id]/likes', type: :request do
  subject { post tweet_likes_path(tweet_id), headers:, as: :json }

  let(:user) { create(:user) }
  let(:headers) { auth_headers(user) }
  let(:tweet) { create(:tweet) }
  let(:tweet_id) { tweet.id }

  context 'when the params are correct' do
    it 'returns 204 status code' do
      subject
      expect(response).to have_http_status(:no_content)
    end

    it 'creates association between user and tweet' do
      subject
      expect(tweet.reload.users_liked).to include(user)
      expect(user.reload.tweets_liked).to include(tweet)
    end
  end

  context 'when the params are incorrect' do
    context 'when the tweet id is invalid' do
      let(:tweet_id) { 'invalid' }

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
