# frozen_string_literal: true

class TweetSerializer < ApplicationSerializer
  identifier :id

  fields :content, :created_at
end
