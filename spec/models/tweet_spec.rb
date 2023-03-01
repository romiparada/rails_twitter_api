# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe 'validations' do
    subject { build(:tweet) }

    context 'content' do
      it { is_expected.to validate_presence_of(:content) }
      it { is_expected.to validate_length_of(:content).is_at_most(280) }
    end

    context 'user' do
      it { is_expected.to belong_to(:user) }
    end
  end
end
