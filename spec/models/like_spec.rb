# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Like, type: :model do
  subject { build(:like, user:, tweet:) }
  let(:user) { build(:user) }
  let(:tweet) { build(:tweet) }

  describe 'validations' do
    context '#like_own_tweet' do
      context 'when user like other tweet' do
        it 'does not add errors to like' do
          subject.send(:like_own_tweet)
          expect(subject.errors[:user]).to be_empty
        end
      end

      context 'when user like his own tweet' do
        let(:user) { tweet.user }

        it 'adds errors to like' do
          subject.send(:like_own_tweet)
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
