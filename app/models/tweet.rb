# frozen_string_literal: true

class Tweet < ApplicationRecord
  validates :content, presence: true, length: { maximum: 280 }

  belongs_to :user, counter_cache: true
end
