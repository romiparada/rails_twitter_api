# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6) }
    confirmed_at { DateTime.now }
    name { Faker::Internet.username(specifier: 2) }
    bio { Faker::Lorem.paragraph_by_chars(number: 160) }
    website do
      ["http://#{Faker::Internet.domain_word}.com", "http://www.#{Faker::Internet.domain_word}.com",
       "https://#{Faker::Internet.domain_word}.com", "https://#{Faker::Internet.domain_word}.com"].sample
    end
    birthdate { Faker::Date.birthday(min_age: 18) }
    username { Faker::Internet.username(specifier: 2..20) }

    trait :unconfirmed do
      confirmed_at { nil }
    end

    trait :without_profile_data do
      name { nil }
      bio { nil }
      website { nil }
      birthdate { nil }
      username { nil }
    end

    after(:create) do |user|
      user.profile_image.attach(io: Rails.root.join('spec/fixtures/files/default_profile.jpeg').open, filename: 'default_profile.jpeg',
                                content_type: 'image/jpeg')
    end
  end
end
