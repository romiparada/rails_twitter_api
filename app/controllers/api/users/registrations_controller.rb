# frozen_string_literal: true

module Api
  module Users
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json
    end
  end
end
