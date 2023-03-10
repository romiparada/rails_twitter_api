# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :tweets, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :tweets_liked, through: :likes, source: :tweet

  has_many :followers, foreign_key: :following_id, class_name: 'Follow', dependent: :destroy, inverse_of: :following
  has_many :followings, foreign_key: :follower_id, class_name: 'Follow', dependent: :destroy, inverse_of: :follower
  has_many :follower_users, through: :followers, source: :follower
  has_many :following_users, through: :followings, source: :following

  has_one_attached :profile_image

  validates :name, length: { minimum: 2 }, allow_blank: true
  validates :bio, length: { maximum: 160 }, allow_blank: true
  validates :website, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }, allow_blank: true
  validates :username, uniqueness: { case_sensitive: false }, length: { in: 2..20 }, allow_blank: true

  validate :over_18_years_old
  validate :update_username_once, on: :update

  def missing_required_fields
    %i[name birthdate username].select do |field|
      send(field).blank?
    end
  end

  private

  def over_18_years_old
    return if birthdate.blank?

    errors.add(:birthdate, 'User must be at least 18 years old') if birthdate > 18.years.ago
  end

  def update_username_once
    return unless will_save_change_to_username?

    return if username_was.nil?

    errors.add(:username, 'can only be changed one time')
  end
end
