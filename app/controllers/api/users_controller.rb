# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    skip_before_action :require_user_fields, only: [:show]

    def show
      render json: UserSerializer.render(current_user)
    end
  end
end
