# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'validations' do
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
      it { is_expected.to allow_value('http://www.valid.com').for(:website) }
      it { is_expected.to allow_value('https://www.valid.com').for(:website) }
      it { is_expected.to allow_value('http://valid.com').for(:website) }
      it { is_expected.to allow_value('https://valid.com').for(:website) }
      it { is_expected.to_not allow_value(Faker::Internet.domain_name).for(:website) }
    end

    describe '#over_18_years_old' do
      context 'when user is over 18' do
        before { subject.birthdate = Faker::Date.birthday(min_age: 18) }

        it 'does not add errors to user' do
          subject.send(:over_18_years_old)
          expect(subject.errors[:birthdate]).to be_empty
        end
      end

      context 'when user is under 18' do
        before { subject.birthdate = Faker::Date.birthday(max_age: 17) }

        it 'adds errors to user' do
          subject.send(:over_18_years_old)
          expect(subject.errors[:birthdate]).to eq(['User must be at least 18 years old'])
        end
      end
    end

    describe '#update_username_once' do
      context 'when the username is not set' do
        before do
          subject.username = nil
          subject.save
          subject.username = 'newusername'
        end

        it 'does not add errors to user' do
          subject.send(:update_username_once)

          expect(subject.errors[:username]).to be_empty
        end
      end

      context 'when the username is set' do
        before do
          subject.save
          subject.username = 'newusername'
        end

        it 'adds errors to user' do
          subject.send(:update_username_once)
          expect(subject.errors[:username]).to eq(['can only be changed one time'])
        end
      end
    end
  end

  describe '#missing_required_fields' do
    context 'whent the username is complete' do
      it 'returns an empty array' do
        expect(subject.missing_required_fields).to be_empty
      end
    end

    context 'when the username is incomplete' do
      subject { build(:user, :without_profile_data) }

      it 'returns the fields name, birthdate and username' do
        expect(subject.missing_required_fields).to eq(%i[name birthdate username])
      end
    end
  end

  describe 'relationships' do
    it { is_expected.to have_many(:tweets) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:tweets_liked).through(:likes).source(:tweet) }
    it { is_expected.to have_many(:followers).dependent(:destroy) }
    it { is_expected.to have_many(:follower_users).through(:followers).source(:follower) }
    it { is_expected.to have_many(:followeds).dependent(:destroy) }
    it { is_expected.to have_many(:followed_users).through(:followeds).source(:followed) }
  end
end
