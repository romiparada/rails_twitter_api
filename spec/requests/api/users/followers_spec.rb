# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/users/:username/followers', type: :request do
  subject { get followers_user_path(username:), headers:, as: :json }

  let(:user) { create(:user) }
  let(:headers) { auth_headers(user) }
  let(:followed_user) { create(:user) }
  let(:username) { followed_user.username }

  before { create_list(:follow, 5, following: followed_user) }

  context 'when the credentials are correct' do
    it 'returns 200 status code' do
      subject
      expect(response).to have_http_status(200)
    end

    it 'returns followers of the user' do
      subject
      expect(json).to eq(JSON.parse(UserSerializer.render(followed_user.follower_users, view: :full)))
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
