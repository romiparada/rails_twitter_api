# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Follow, type: :model do
  subject { build(:follow, following:, follower:) }

  let(:following) { create(:user) }
  let(:follower) { create(:user) }

  describe 'validations' do
    context 'follower_id' do
      it { is_expected.to validate_uniqueness_of(:follower_id).scoped_to(:following_id) }
    end

    context '#follows_himself' do
      context 'when following and follower are not the same' do
        it 'does not add errors to follow' do
          subject.send(:follows_himself)
          expect(subject.errors[:follow]).to be_empty
        end
      end

      context 'when following and follower are the same' do
        let(:following) { follower }

        it 'adds errors to follow' do
          subject.send(:follows_himself)
          expect(subject.errors[:follow]).to eq(["can't follow himself"])
        end
      end
    end
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:following) }
    it { is_expected.to belong_to(:follower) }
  end
end
