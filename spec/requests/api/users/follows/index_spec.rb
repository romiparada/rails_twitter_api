# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/users/:user_username/follows', type: :request do
  subject { get user_follows_path(user_username:, **params), headers:, as: :json }

  let(:user) { create(:user) }
  let(:headers) { auth_headers(user) }
  let(:follows_user) { create(:user) }
  let(:user_username) { follows_user.username }
  let(:params) { {} }
  let!(:followers) { follows_user.follower_users << create_list(:user, 5) }
  let!(:followings) { follows_user.following_users << create_list(:user, 5) }

  context 'when the credentials are correct' do
    context 'when no params are passed' do
      it 'returns 200 status code' do
        subject
        expect(response).to have_http_status(200)
      end

      it 'returns follows of the user' do
        subject
        expect(json).to eq(JSON.parse(UserSerializer.render(followers + followings, view: :full)))
      end
    end

    context 'when the followers param is set' do
      let(:params) do
        {
          followers: true
        }
      end

      it 'returns 200 status code' do
        subject
        expect(response).to have_http_status(200)
      end

      it 'returns followers of the user' do
        subject
        expect(json).to eq(JSON.parse(UserSerializer.render(followers, view: :full)))
      end
    end
  end

  context 'when the params are incorrect' do
    context 'when the username is invalid' do
      let(:user_username) { 'invalid' }

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
