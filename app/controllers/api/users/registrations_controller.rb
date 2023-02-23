# frozen_string_literal: true

module Api
  module Users
    class RegistrationsController < Devise::RegistrationsController
      include FakeSession
      respond_to :json
    end
  end
end
