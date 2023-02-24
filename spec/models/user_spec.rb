# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user, :full) }

    context 'email' do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end

    context 'password' do
      it { is_expected.to validate_presence_of(:password) }
    end

    context 'username' do
      it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
      it { is_expected.to validate_length_of(:username).is_at_least(2).is_at_most(20) }
    end

    context 'name' do
      it { is_expected.to validate_length_of(:name).is_at_least(2) }
    end

    context 'bio' do
      it { is_expected.to validate_length_of(:bio).is_at_most(160) }
    end

    context 'validates website format' do
      it { is_expected.to_not allow_value(Faker::Internet.domain_name).for(:website) }
    end

    context 'validates birthday' do
      it { is_expected.to_not allow_value(Faker::Date.birthday(max_age: 17)).for(:birthdate) }
    end
  end
end
