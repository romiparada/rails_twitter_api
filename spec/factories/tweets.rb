# frozen_string_literal: true

FactoryBot.define do
  factory :tweet do
    content { Faker::Lorem.paragraph_by_chars(number: 280) }
    user { nil }
  end
end
