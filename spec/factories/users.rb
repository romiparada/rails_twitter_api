# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 8) }
    confirmed_at { DateTime.now }

    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end
