# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Like, type: :model do
  subject { build(:like, user:, tweet:) }

  let(:user) { create(:user) }
  let(:tweet) { create(:tweet) }

  describe 'validations' do
    context '#likes_own_tweet' do
      context 'when user likes other tweet' do
        it 'does not add errors to likes' do
          subject.send(:likes_own_tweet)
          expect(subject.errors[:user]).to be_empty
        end
      end

      context 'when user likes his own tweet' do
        let(:user) { tweet.user }

        it 'adds errors to likes' do
          subject.send(:likes_own_tweet)
          expect(subject.errors[:user]).to eq(["can't like his own tweet"])
        end
      end
    end
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:tweet) }
  end
end
