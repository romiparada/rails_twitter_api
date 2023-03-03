# frozen_string_literal: true

module AuthHelper
  def get_jwt(user)
    auth_headers = Devise::JWT::TestHelpers.auth_headers({}, user)
    auth_headers['Authorization']
  end

  def auth_headers(user)
    { 'Authorization' => get_jwt(user) }
  end
end
