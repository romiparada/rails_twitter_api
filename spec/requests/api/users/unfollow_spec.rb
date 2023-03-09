# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/users/:username/unfollow', type: :request do
  subject { post unfollow_user_path(username), headers:, as: :json }

  let(:user) { create(:user) }
  let(:headers) { auth_headers(user) }
  let(:following) { create(:user) }
  let(:username) { following.username }

  context 'when the params are correct' do
    context 'when the user unfollows a following user' do
      let!(:follow) { create(:follow, follower: user, following:) }

      it 'returns 204 status code' do
        subject
        expect(response).to have_http_status(:no_content)
      end

      it 'deletes follow' do
        expect { subject }.to change { user.followings.count }.from(1).to(0)
        expect { follow.reload }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the user unfollows a non following user' do
      it 'returns 404 status code' do
        subject
        expect(response).to have_http_status(:not_found)
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
