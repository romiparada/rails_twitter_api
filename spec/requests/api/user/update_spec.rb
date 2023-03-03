# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PUT /api/user', type: :request do
  subject { put user_path, params:, headers:, as: :json }

  let(:user) { create(:user, :without_profile_data) }
  let(:headers) { auth_headers(user) }
  let(:new_attributes) { attributes_for(:user).except(:confirmed_at) }
  let(:name) { new_attributes[:name] }
  let(:bio) { new_attributes[:bio] }
  let(:website) { new_attributes[:website] }
  let(:email) { new_attributes[:email] }
  let(:birthdate) { new_attributes[:birthdate] }
  let(:password) { new_attributes[:password] }
  let(:username) { new_attributes[:username] }

  let(:params) do
    {
      user: {
        name:,
        bio:,
        website:,
        email:,
        birthdate:,
        password:,
        username:
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
        json_res = json
        expect(json_res['name']).to eq(user.name)
        expect(json_res['bio']).to eq(user.bio)
        expect(json_res['website']).to eq(user.website)
        expect(json_res['email']).to eq(user.email)
        expect(json_res['created_at']).to eq(user.created_at.strftime('%Y-%m-%d %H:%M:%S UTC'))
      end

      it 'modifies user profile info' do
        expect do
          subject
          user.reload
        end.to change { user.name }.to(eq(name)).and \
          change { user.bio }.to(eq(bio)).and \
            change { user.website }.to(eq(website)).and \
              change { user.email }.to(eq(email)).and \
                change { user.valid_password?(password) }.to(be_truthy).and \
                  change { user.username }.to(eq(username))
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

        it 'does not update the user' do
          expect { subject }.to_not(change { user.reload.updated_at })
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

        it 'does not update the user' do
          expect { subject }.to_not(change { user.reload.updated_at })
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

        it 'does not update the user' do
          expect { subject }.to_not(change { user.reload.updated_at })
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

        it 'does not update the user' do
          expect { subject }.to_not(change { user.reload.updated_at })
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

        it 'does not update the user' do
          expect { subject }.to_not(change { user.reload.updated_at })
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

        it 'does not update the user' do
          expect { subject }.to_not(change { user.reload.updated_at })
        end
      end

      context 'when the handle (username) is set' do
        before { user.update({ username: 'username' }) }

        it 'does not update the user' do
          expect { subject }.to_not(change { user.reload.updated_at })
        end

        it 'returns the correct error message' do
          subject
          expect(errors['username']).to eq(['can only be changed one time'])
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

        it 'does not update the user' do
          expect { subject }.to_not(change { user.reload.updated_at })
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

      it 'does not update the user' do
        expect { subject }.to_not(change { user.reload.updated_at })
      end
    end
  end
end
