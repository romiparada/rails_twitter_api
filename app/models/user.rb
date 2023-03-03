# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :name, length: { minimum: 2 }, allow_blank: true
  validates :bio, length: { maximum: 160 }, allow_blank: true
  validates :website, format: { with: %r{https?://(www\.)?(.*)\.com} }, allow_blank: true
  validates :username, uniqueness: { case_sensitive: false }, length: { in: 2..20 }, allow_blank: true

  validate :over_eighteen

  def missing_require_fields
    %i[name birthdate username].select do |field|
      send(field).blank?
    end
  end

  private

  def over_eighteen
    return if birthdate.blank?

    errors.add(:birthdate, 'User must be at least 18 years old') if birthdate > 18.years.ago
  end
end
