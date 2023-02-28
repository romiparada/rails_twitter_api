# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 8) }
    confirmed_at { DateTime.now }

    trait :unconfirmed do
      confirmed_at { nil }
    end

    trait :full do
      name { Faker::Internet.username(specifier: 2) }
      bio { Faker::Lorem.paragraph_by_chars(number: 160) }
      website do
        ["http://#{Faker::Internet.domain_word}.com", "http://www.#{Faker::Internet.domain_word}.com",
         "https://#{Faker::Internet.domain_word}.com", "https://#{Faker::Internet.domain_word}.com"].sample
      end
      birthdate { Faker::Date.birthday(min_age: 18) }
      username { Faker::Internet.username(specifier: 2..20) }
    end
  end
end
