# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    skip_before_action :user_profile_filled, only: :show

    def show
      render json: UserSerializer.render(current_user)
    end
  end
end
