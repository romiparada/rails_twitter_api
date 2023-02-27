# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/users/password', type: :request do
  subject { post user_password_path, params:, as: :json }

  let(:user) { create(:user) }
  let(:email) { user.email }

  let(:params) do
    {
      user: { email: }
    }
  end

  context 'when the email is correct' do
    it 'returns 201 status code' do
      subject
      expect(response).to have_http_status(:created)
    end

    it 'sends mail with reset passwords instructions' do
      expect { subject }.to change { ActionMailer::Base.deliveries.count }.from(0).to(1)
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to eq([email])
      expect(mail.body).to match('reset_password_token')
    end

    it 'stores the reset password token in the user' do
      subject
      expect(user.reload.reset_password_token).to_not be_nil
    end
  end

  context 'when the email is incorrect' do
    let(:email) { Faker::Internet.email }

    it 'returns 422 status code' do
      subject
      expect(response).to have_http_status(422)
    end

    it 'does not sends reset passwords instructions' do
      expect { subject }.to_not(change { ActionMailer::Base.deliveries.count })
    end

    it 'returns a not found error message' do
      subject
      expect(errors['email']).to eq(['not found'])
    end
  end
end
