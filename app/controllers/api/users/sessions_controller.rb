# frozen_string_literal: true

module Api
  module Users
    class SessionsController < Devise::SessionsController
      respond_to :json
    end
  end
end
