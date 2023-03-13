# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/tweets/:id', type: :request do
  subject { get tweet_path(tweet_id), headers:, as: :json }

  let(:tweet) { create(:tweet) }
  let(:user) { tweet.user }
  let(:headers) { auth_headers(user) }
  let(:tweet_id) { tweet.id }

  context 'when the params are correct' do
    it 'returns 200 status code' do
      subject
      expect(response).to have_http_status(200)
    end

    it 'returns tweet info' do
      subject
      json_res = json
      expect(json_res['content']).to eq(tweet.content)
      expect(json_res['created_at']).to eq(tweet.created_at.strftime('%Y-%m-%d %H:%M:%S UTC'))
      expect(json_res['user']['id']).to eq(tweet.user.id)
      expect(json_res['user']['name']).to eq(tweet.user.name)
      expect(json_res['user']['username']).to eq(tweet.user.username)
    end
  end

  context 'when the params are incorrect' do
    context 'when the id is invalid' do
      let(:tweet_id) { 0 }

      it 'returns 404 status code' do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found error message' do
        subject
        expect(errors).to eq('resource could not be found')
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
