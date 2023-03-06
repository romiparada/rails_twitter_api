# frozen_string_literal: true

class Tweet < ApplicationRecord
  validates :content, presence: true, length: { maximum: 280 }

  belongs_to :user, counter_cache: true
  has_many :likes, dependent: :destroy
  has_many :liked_by, through: :likes, source: :user
end
