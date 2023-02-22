# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/users', type: :request do
  subject { post user_registration_path, params:, as: :json }

  let(:params) do
    {
      user: {
        email:,
        password:,
        password_confirmation:
      }
    }
  end

  context 'when the credentials are correct' do
    let!(:user) { build(:user) }
    let(:email) { user.email }
    let(:password) { user.password }
    let(:password_confirmation) { user.password }

    it 'returns 201 status code' do
      subject
      expect(response).to have_http_status(:created)
    end

    it 'returns a valid user id' do
      subject
      user_id = json['id']
      expect(User.exists?(user_id)).to be_truthy
    end
  end

  context 'when the credentials are incorrect' do
    context 'when the email is incorrect' do
      let(:user) { build(:user) }
      let(:password) { user.password }
      let(:password_confirmation) { user.password }

      context 'when the email is taken' do
        let(:email) { user.email }
        before { user.save }

        it 'returns 422 status code' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'returns an email taken error message' do
          subject
          expect(errors['email']).to eq(['has already been taken'])
        end
      end

      context 'when the email is empty' do
        let(:email) { '' }

        it 'returns 422 status code' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'returns a blank email error message' do
          subject
          expect(errors['email']).to eq(["can't be blank"])
        end
      end

      context 'when the email is invalid' do
        let(:email) { 'invalid' }

        it 'returns 422 status code' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'returns an invalid email error message' do
          subject
          expect(errors['email']).to eq(['is invalid'])
        end
      end
    end

    context 'when the password is incorrect' do
      let(:email) { build(:user).email }
      let(:password_confirmation) { password }

      context 'when the password is invalid' do
        let(:password) { Faker::Internet.password(min_length: 2, max_length: 5) }

        it 'returns 422 status code' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'returns a short password error message' do
          subject
          expect(errors['password']).to eq(['is too short (minimum is 6 characters)'])
        end
      end

      context 'when the password is empty' do
        let(:password) { '' }

        it 'returns 422 status code' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'returns a blank password error message' do
          subject
          expect(errors['password']).to eq(["can't be blank"])
        end
      end
    end

    context 'when the password_confirmation is incorrect' do
      let(:user) { build(:user) }
      let(:email) { user.email }
      let(:password) { user.password }

      context 'when the password_confirmation is empty' do
        let(:password_confirmation) { '' }

        it 'returns 422 status code' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'returns a match password_confirmation error message' do
          subject
          expect(errors['password_confirmation']).to eq(["doesn't match Password"])
        end
      end

      context 'when the password_confirmation differs' do
        let(:password_confirmation) { build(:user).password }

        it 'returns 422 status code' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'returns a match password_confirmation error message' do
          subject
          expect(errors['password_confirmation']).to match(["doesn't match Password"])
        end
      end
    end
  end
end
