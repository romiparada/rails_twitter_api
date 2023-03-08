# frozen_string_literal: true

FactoryBot.define do
  factory :follow do
    following factory: :user
    follower factory: :user
  end
end
