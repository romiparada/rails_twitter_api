# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/tweets', type: :request do
  subject { post tweets_path, params:, headers:, as: :json }

  let(:user) { create(:user) }
  let(:headers) { auth_headers(user) }
  let(:tweet) { build(:tweet) }
  let(:content) { tweet.content }

  let(:params) do
    {
      tweet: {
        content:
      }
    }
  end

  context 'when the params are correct' do
    let(:id) { json['id'] }

    it 'returns 201 status code' do
      subject
      expect(response).to have_http_status(:created)
    end

    it 'returns a valid tweet id' do
      subject
      expect(Tweet.exists?(id)).to be_truthy
    end

    it 'creates a tweet associated with the user' do
      subject
      tweet = Tweet.find(id)
      expect(tweet.user).to eq(user)
      expect(user.reload.tweets).to include(tweet)
    end
  end

  context 'when the params are incorrect' do
    context 'when the content is incorrect' do
      context 'when the content is empty' do
        let(:content) { {} }

        it 'returns 422 status code' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'returns a blank content error message' do
          subject
          expect(errors['content']).to eq(["can't be blank"])
        end
      end

      context 'when the content is invalid' do
        let(:content) { Faker::Lorem.paragraph_by_chars(number: 281) }

        it 'returns 422 status code' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'returns a long content error message' do
          subject
          expect(errors['content']).to eq(['is too long (maximum is 280 characters)'])
        end
      end
    end

    context 'when the auth header is not set' do
      let(:headers) { {} }

      it 'returns 401 status code' do
        subject
        expect(response).to have_http_status(401)
      end
    end
  end
end
