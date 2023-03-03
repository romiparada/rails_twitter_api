# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/users/[:username]/tweets', type: :request do
  subject { get user_tweets_path(username), headers:, as: :json }

  let(:user) { create(:user, :with_tweets) }
  let(:username) { user.username }
  let(:headers) { auth_headers(user) }

  context 'when the credentials are correct' do
    it 'returns 200 status code' do
      subject
      expect(response).to have_http_status(200)
    end

    it 'returns tweets in order' do
      subject
      expect(json).to eq(JSON.parse(TweetSerializer.render(user.tweets.order(created_at: :desc))))
    end
  end

  context 'when the params are incorrect' do
    context 'when the username is invalid' do
      let(:username) { 'invalid' }

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
