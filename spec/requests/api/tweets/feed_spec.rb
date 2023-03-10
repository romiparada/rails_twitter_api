# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/tweets/feed', type: :request do
  subject { get feed_tweets_path, headers:, as: :json }

  let(:user) { create(:user) }
  let(:user_tweet) { create(:tweet, user:) }
  let(:headers) { auth_headers(user) }
  let(:following1) { create(:user) }
  let!(:tweet1) { create(:tweet, user: following1, created_at: 1.day.ago) }
  let(:following2) { create(:user) }
  let!(:tweet2) { create(:like, user: following2).tweet }

  before do
    create(:follow, following: following1, follower: user)
    create(:follow, following: following2, follower: user)
  end

  context 'when the credentials are correct' do
    it 'returns 200 status code' do
      subject
      expect(response).to have_http_status(200)
    end

    it 'returns the tweets authored and liked by users being followed by the user' do
      subject
      expect(json).to eq(JSON.parse(TweetSerializer.render([tweet2, tweet1])))
    end

    it 'does not returns the tweets created by the user' do
      subject
      expect(json).not_to include JSON.parse(TweetSerializer.render(user_tweet))
    end
  end

  context 'when the params are incorrect' do
    context 'when the auth header is not set' do
      let(:headers) { {} }

      it 'returns 401 status code' do
        subject
        expect(response).to have_http_status(401)
      end
    end
  end
end
