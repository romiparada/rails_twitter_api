# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/users/sign_up', type: :request do
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

    it 'responds with valid user id' do
      subject
      user_id = json['id']
      expect(User.exists?(user_id)).to be_truthy
    end
  end

  context 'when the credentials are incorrect' do
    context 'when the email incorrect' do
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

        it 'responds with taken email message' do
          subject
          expect(errors['email'][0]).to match(/taken/)
        end
      end

      context 'when the email is empty' do
        let(:email) { '' }
        it 'returns 422 status code' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'responds with blank email message' do
          subject
          expect(errors['email'][0]).to match(/blank/)
        end
      end

      context 'when the email is invalid' do
        let(:email) { 'invalid' }

        it 'returns 422 status code' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'responds with invalid email message' do
          subject
          expect(errors['email'][0]).to match(/invalid/)
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

        it 'responds with short password message' do
          subject
          expect(errors['password'][0]).to match(/short/)
        end
      end

      context 'when the password is empty' do
        let(:password) { '' }

        it 'returns 422 status code' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'responds with blank password message' do
          subject
          expect(errors['password'][0]).to match(/blank/)
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

        it 'responds with match password_confirmation message' do
          subject
          expect(errors['password_confirmation'][0]).to match(/match/)
        end
      end

      context 'when the password_confirmation differs' do
        let(:password_confirmation) { build(:user).password }

        it 'returns 422 status code' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'responds with match password_confirmation message' do
          subject
          expect(errors['password_confirmation'][0]).to match(/match/)
        end
      end
    end
  end
end
