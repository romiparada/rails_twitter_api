# frozen_string_literal: true

FactoryBot.define do
  factory :like do
    user
    tweet
  end
end
