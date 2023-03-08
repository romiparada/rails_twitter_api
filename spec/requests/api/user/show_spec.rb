# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/user', type: :request do
  subject { get user_path, headers:, as: :json }

  let(:user) { create(:user) }
  let(:headers) { auth_headers(user) }

  context 'when the valid auth headers are passed' do
    it 'returns 200 status code' do
      subject
      expect(response).to have_http_status(200)
    end

    it 'returns user profile info' do
      subject
      json_res = json
      expect(json_res['name']).to eq(user.name)
      expect(json_res['bio']).to eq(user.bio)
      expect(json_res['website']).to eq(user.website)
      expect(json_res['email']).to eq(user.email)
      expect(json_res['created_at']).to eq(user.created_at.strftime('%Y-%m-%d %H:%M:%S UTC'))
      expect(json_res['username']).to eq(user.username)
      expect(json_res['followers_count']).to eq(user.followers_count)
      expect(json_res['followings_count']).to eq(user.followings_count)
    end
  end

  context 'when invalid auth headers are passed' do
    context 'when the auth header is not set' do
      let(:headers) { {} }

      it 'returns 422 status code' do
        subject
        expect(response).to have_http_status(401)
      end
    end
  end
end
