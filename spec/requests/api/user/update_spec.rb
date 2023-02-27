# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/user', type: :request do
  subject { put user_path, params:, headers:, as: :json }

  let(:user) { create(:user) }
  let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, user) }
  let(:new_attributes) { attributes_for(:user).except(:username, :confirmed_at) }
  let(:name) { new_attributes[:name] }
  let(:bio) { new_attributes[:bio] }
  let(:website) { new_attributes[:website] }
  let(:email) { new_attributes[:email] }
  let(:birthdate) { new_attributes[:birthdate] }
  let(:password) { new_attributes[:password] }

  let(:params) do
    {
      user: {
        name:,
        bio:,
        website:,
        email:,
        birthdate:,
        password:
      }
    }
  end

  context 'when the credentials are correct' do
    context 'when the params are correct' do
      it 'returns 200 status code' do
        subject
        expect(response).to have_http_status(200)
      end

      it 'returns user profile info' do
        subject
        user.reload
        expect(json['name']).to eq(user.name)
        expect(json['bio']).to eq(user.bio)
        expect(json['website']).to eq(user.website)
        expect(json['email']).to eq(user.email)
        expect(json['created_at']).to eq(user.created_at.strftime('%Y-%m-%d %H:%M:%S UTC'))
      end

      it 'modifies user profile info' do
        subject
        user.reload
        expect(user.name).to eq(name)
        expect(user.bio).to eq(bio)
        expect(user.website).to eq(website)
        expect(user.email).to eq(email)
        expect(user.reload.valid_password?(password)).to be_truthy
      end
    end

    context 'when the params are incorrect' do
      context 'when the name is invalid' do
        let(:name) { Faker::Internet.username(specifier: 0..1) }

        it 'returns 422 status' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'returns an invalid name error message' do
          subject
          expect(errors['name']).to eq(['is too short (minimum is 2 characters)'])
        end

        it 'does not change the name' do
          expect { subject }.to_not(change { user.reload.name })
        end
      end

      context 'when the bio is invalid' do
        let(:bio) { Faker::Lorem.paragraph_by_chars(number: 161) }

        it 'returns 422 status' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'returns an invalid bio error message' do
          subject
          expect(errors['bio']).to eq(['is too long (maximum is 160 characters)'])
        end

        it 'does not change the bio' do
          expect { subject }.to_not(change { user.reload.bio })
        end
      end

      context 'when the website is invalid' do
        let(:website) { Faker::Internet.domain_word }

        it 'returns 422 status' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'returns an invalid website error message' do
          subject
          expect(errors['website']).to eq(['is invalid'])
        end

        it 'does not change the website' do
          expect { subject }.to_not(change { user.reload.website })
        end
      end

      context 'when the email is invalid' do
        let(:email) { 'invalid' }

        it 'returns 422 status' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'returns an invalid bio error message' do
          subject
          expect(errors['email']).to eq(['is invalid'])
        end

        it 'does not change the email' do
          expect { subject }.to_not(change { user.reload.email })
        end
      end

      context 'when the birthdate is invalid' do
        let(:birthdate) { DateTime.now }

        it 'returns 422 status' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'returns an invalid birthdate error message' do
          subject
          expect(errors['birthdate']).to eq(['User must be at least 18 years old'])
        end

        it 'does not change the birthdate' do
          expect { subject }.to_not(change { user.reload.birthdate })
        end
      end

      context 'when the password is invalid' do
        let(:password) { 'inva' }

        it 'returns 422 status' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'returns an invalid password error message' do
          subject
          expect(errors['password']).to eq(['is too short (minimum is 6 characters)'])
        end

        it 'does not change the password' do
          expect { subject }.to_not(change { user.reload.password })
        end
      end

      context 'when the handle (username) is set' do
        let(:params) do
          {
            user: {
              username: 'newusername'
            }
          }
        end

        it 'does not change the username' do
          expect { subject }.to_not(change { user.reload.username })
        end
      end

      context 'when created_at is set' do
        let(:params) do
          {
            user: {
              created_at: DateTime.now
            }
          }
        end

        it 'does not change created_at field' do
          expect { subject }.to_not(change { user.reload.created_at })
        end
      end
    end
  end

  context 'when the credentials are incorrect' do
    context 'when the auth header is not set' do
      let(:headers) { {} }
      it 'returns 401 status code' do
        subject
        expect(response).to have_http_status(401)
      end
    end

    context 'when the auth header is incorrect' do
      let(:headers) { Devise::JWT::TestHelpers.auth_headers({}, build(:user)) }

      it 'returns 401 status code' do
        subject
        expect(response).to have_http_status(401)
      end
    end
  end
end
