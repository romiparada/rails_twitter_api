# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/user', type: :request do
  subject { get user_path, headers:, as: :json }

  let(:user) { create(:user) }
  let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, user) }

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
    end
  end

  context 'when the credentials are incorrect' do
    context 'when the auth header is not set' do
      let(:headers) { {} }

      it 'returns 422 status code' do
        subject
        expect(response).to have_http_status(401)
      end

      it 'revokes the user jwt token' do
        expect { subject }.to_not(change { user.reload.jti })
      end
    end

    context 'when the auth header is incorrect' do
      let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, build(:user)) }

      it 'returns 401 status code' do
        subject
        expect(response).to have_http_status(401)
      end

      it 'revokes the user jwt token' do
        expect { subject }.to_not(change { user.reload.jti })
      end
    end
  end
end
