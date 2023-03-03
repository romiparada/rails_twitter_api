# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tweet, type: :model do
  subject { build(:tweet) }

  describe 'validations' do
    context 'content' do
      it { is_expected.to validate_presence_of(:content) }
      it { is_expected.to validate_length_of(:content).is_at_most(280) }
    end
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:user) }
  end
end
