# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/users/sign_in' do
  subject { post user_session_path, params:, as: :json }

  let!(:user) { create(:user, password: 'juan_123') }

  let(:params) do
    {
      user: {
        email:,
        password:
      }
    }
  end

  context 'when the credentials are correct' do
    let(:email) { user.email }
    let(:password) { user.password }

    it 'returns 200 status code' do
      subject
      expect(response).to have_http_status(:created)
    end

    it 'returns a valid bearer token in the heades' do
      subject
      expect(headers['Authorization']).to match(/Bearer .*/)
    end
  end

  context 'when the credentials are incorrect' do
    context 'when the email does not exist' do
      let(:email) { Faker::Internet.email }
      let(:password) { user.password }

      it 'returns 401 status code' do
        subject
        expect(response).to have_http_status(401)
      end

      it 'returns an invalid bearer token in the heades' do
        subject
        expect(headers['Authorization']).to be_nil
      end
    end

    context 'when the password is incorrect' do
      let(:email) { user.email }
      let(:password) { Faker::Internet.password }

      it 'returns 401 status code' do
        subject
        expect(response).to have_http_status(401)
      end

      it 'returns an invalid bearer token in the heades' do
        subject
        expect(headers['Authorization']).to be_nil
      end
    end
  end
end
