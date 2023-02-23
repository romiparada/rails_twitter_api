# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/users/sign_in', type: :request do
  subject { post user_session_path, params:, as: :json }

  let!(:user) { create(:user) }
  let(:email) { user.email }
  let(:password) { user.password }

  let(:params) do
    {
      user: {
        email:,
        password:
      }
    }
  end

  context 'when the user is not confirmed' do
    it 'returns 401 status code' do
      subject
      expect(response).to have_http_status(401)
    end

    it 'does not return an Authorization header' do
      subject
      expect(headers['Authorization']).to be_nil
    end
  end

  context 'when the user is confirmed' do
    before { user.confirm }

    context 'when the credentials are correct' do
      it 'returns 200 status code' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'returns a valid bearer token in the heades' do
        subject
        expect(headers['Authorization']).to match(/Bearer .*/)
      end

      it 'returns email and created_at fields' do
        subject
        expect(json['email']).to eq(user.email)
        expect(json['created_at']).to eq(user.created_at.strftime('%Y-%m-%d %H:%M:%S UTC'))
      end
    end

    context 'when the credentials are incorrect' do
      context 'when the email does not exist' do
        let(:email) { Faker::Internet.email }

        it 'returns 401 status code' do
          subject
          expect(response).to have_http_status(401)
        end

        it 'does not return an Authorization header' do
          subject
          expect(headers['Authorization']).to be_nil
        end
      end

      context 'when the password is incorrect' do
        let(:password) { Faker::Internet.password }

        it 'returns 401 status code' do
          subject
          expect(response).to have_http_status(401)
        end

        it 'does not return an Authorization header' do
          subject
          expect(headers['Authorization']).to be_nil
        end
      end
    end
  end
end
