# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  identifier :id

  fields :name, :bio, :website, :email, :created_at, :username
end
