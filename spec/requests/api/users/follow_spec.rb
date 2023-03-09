# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/users/:username/follow', type: :request do
  subject { post follow_user_path(username), headers:, as: :json }

  let(:user) { create(:user) }
  let(:headers) { auth_headers(user) }
  let(:following) { create(:user) }
  let(:username) { following.username }

  context 'when the params are correct' do
    context 'when the user follows different user' do
      it 'returns 204 status code' do
        subject
        expect(response).to have_http_status(:no_content)
      end

      it 'creates follow' do
        subject
        expect(following.follower_users).to include(user)
        expect(user.following_users).to include(following)
      end
    end

    context 'when the user follows himself' do
      let(:following) { user }

      it 'returns 422 status code' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the correct error message' do
        subject
        expect(errors['follow']).to eq(["can't follow himself"])
      end
    end

    context 'when the user follows the same user twice' do
      before { following.follower_users << user }

      it 'returns 422 status code' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the correct error message' do
        subject
        expect(errors['follower_id']).to eq(['has already been taken'])
      end
    end
  end

  context 'when the params are incorrect' do
    context 'when the tweet id is invalid' do
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
