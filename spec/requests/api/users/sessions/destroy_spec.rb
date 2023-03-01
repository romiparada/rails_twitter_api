# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /api/users/sign_out', type: :request do
  subject { delete destroy_user_session_path, params: {}, headers:, as: :json }

  let(:user) { create(:user) }
  let(:headers) { auth_headers(user) }

  context 'when the credentials are correct' do
    it 'returns 204 status code' do
      subject
      expect(response).to have_http_status(204)
    end

    it 'revokes the user jwt token' do
      expect { subject }.to(change { user.reload.jti })
    end
  end

  context 'when the credentials are incorrect' do
    context 'when the auth header is not set' do
      let(:headers) { {} }

      it 'returns 204 status code' do
        subject
        expect(response).to have_http_status(204)
      end

      it 'does not revoke the user jwt token' do
        expect { subject }.to_not(change { user.reload.jti })
      end
    end

    context 'when the auth header is incorrect' do
      let(:headers) { auth_headers(create(:user)) }

      it 'returns 204 status code' do
        subject
        expect(response).to have_http_status(204)
      end

      it 'does not revoke the user jwt token' do
        expect { subject }.to_not(change { user.reload.jti })
      end
    end
  end
end
