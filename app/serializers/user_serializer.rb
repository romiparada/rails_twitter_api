# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  identifier :id

  view :simple do
    fields :name, :username
  end

  view :full do
    include_view :simple
    fields :bio, :website, :email, :created_at, :tweets_count, :followers_count, :followings_count
    field :profile_image do |user|
      Rails.application.routes.url_helpers.rails_blob_path(user.profile_image, only_path: true) if user.profile_image.attached?
    end
  end
end
