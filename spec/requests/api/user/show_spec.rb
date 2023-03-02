# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/user', type: :request do
  subject { get user_path, headers:, as: :json }

  let(:user) { create(:user) }
  let(:headers) { auth_headers(user) }

  context 'when the credentials are correct' do
    it 'returns 200 status code' do
      subject
      expect(response).to have_http_status(200)
    end

    it 'returns user profile info' do
      subject
      expect(json['name']).to eq(user.name)
      expect(json['bio']).to eq(user.bio)
      expect(json['website']).to eq(user.website)
      expect(json['email']).to eq(user.email)
      expect(json['created_at']).to eq(user.created_at.strftime('%Y-%m-%d %H:%M:%S UTC'))
      expect(json['username']).to eq(user.username)
    end
  end

  context 'when the credentials are incorrect' do
    context 'when the auth header is not set' do
      let(:headers) { {} }

      it 'returns 422 status code' do
        subject
        expect(response).to have_http_status(401)
      end
    end
  end
end
