# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PUT /api/users/password?reset_password_token', type: :request do
  subject { put user_password_path, params:, as: :json }

  let(:user) { create(:user) }
  let(:reset_password_token) { user.send(:set_reset_password_token) }
  let(:password) { Faker::Internet.password(min_length: 8) }

  let(:params) do
    {
      user: {
        password:,
        reset_password_token:
      }
    }
  end

  before { user.confirm }

  context 'when the params are correct' do
    it 'returns 204 status code' do
      subject
      expect(response).to have_http_status(204)
    end

    it 'resets password' do
      subject
      expect(user.reload.valid_password?(password)).to be_truthy
    end
  end

  context 'when the params are incorrect' do
    context 'when the reset password token is incorrect' do
      context 'when the reset password token is not sent' do
        let(:params) do
          {
            user: {
              password:
            }
          }
        end

        it 'returns 422 status code' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'does not reset password' do
          expect { subject }.to_not(change { user.reload.password })
        end

        it 'returns an invalid error message' do
          subject
          expect(errors['reset_password_token']).to eq(["can't be blank"])
        end
      end

      context 'when the reset password token is empty' do
        let(:reset_password_token) { '' }

        it 'returns 422 status code' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'does not reset password' do
          expect { subject }.to_not(change { user.reload.password })
        end

        it 'returns an invalid error message' do
          subject
          expect(errors['reset_password_token']).to eq(["can't be blank"])
        end
      end

      context 'when the reset password token is invalid' do
        let(:reset_password_token) { Faker::Internet.device_token }

        it 'returns 422 status code' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'does not reset password' do
          expect { subject }.to_not(change { user.reload.password })
        end

        it 'returns an invalid error message' do
          subject
          expect(errors['reset_password_token']).to eq(['is invalid'])
        end
      end
    end

    context 'when the password is incorrect' do
      context 'when the password is not sent' do
        let(:params) do
          {
            user: {
              reset_password_token:
            }
          }
        end

        it 'returns 422 status code' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'does not reset password' do
          expect { subject }.to_not(change { user.reload.password })
        end

        it 'returns an invalid error message' do
          subject
          expect(errors['password']).to eq(["can't be blank"])
        end
      end

      context 'when the password is empty' do
        let(:password) { '' }

        it 'returns 422 status code' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'does not reset password' do
          expect { subject }.to_not(change { user.reload.password })
        end

        it 'returns an invalid error message' do
          subject
          expect(errors['password']).to eq(["can't be blank"])
        end
      end

      context 'when the password is invalid' do
        let(:password) { Faker::Internet.password(min_length: 2, max_length: 5) }

        it 'returns 422 status code' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'does not reset password' do
          expect { subject }.to_not(change { user.reload.password })
        end

        it 'returns an invalid error message' do
          subject
          expect(errors['password']).to eq(['is too short (minimum is 6 characters)'])
        end
      end
    end
  end
end
