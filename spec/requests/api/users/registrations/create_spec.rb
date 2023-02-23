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

  let(:user) { build(:user) }
  let(:email) { user.email }
  let(:password) { user.password }
  let(:password_confirmation) { user.password }

  context 'when the credentials are correct' do
    context 'when all params are sent' do
      let(:user_id) { json['id'] }

      it 'returns 201 status code' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'returns a valid user id' do
        subject
        expect(User.exists?(user_id)).to be_truthy
      end

      it 'sends a confirmation email' do
        expect { subject }.to change { ActionMailer::Base.deliveries.count }.from(0).to(1)
        mail = ActionMailer::Base.deliveries.last
        expect(mail.to).to eq([email])
        expect(mail.body).to match('confirmation_token')
      end

      it 'stores the confirmation token in the user ' do
        subject
        expect(User.find(user_id).confirmation_token).to_not be_nil
      end
    end

    context 'when the password_confirmation param is not sent' do
      let(:params) do
        {
          user: {
            email:,
            password:
          }
        }
      end

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
  end

  context 'when the credentials are incorrect' do
    context 'when the email is incorrect' do
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
        let(:password_confirmation) { Faker::Internet.password(min_length: 8) }

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
