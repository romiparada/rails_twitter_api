# frozen_string_literal: true

module Api
  module Users
    class SessionsController < Devise::SessionsController
      respond_to :json
      def create
        super do |user|
          render json: UserSerializer.render(user), status: :created
          return
        end
      end
    end
  end
end
