# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  identifier :id

  view :simple do
    fields :name, :username
  end

  view :full do
    include_view :simple
    fields :bio, :website, :email, :created_at, :tweets_count
  end
end
