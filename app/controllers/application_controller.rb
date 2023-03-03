# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  respond_to :json
  before_action :authenticate_user!
  before_action :user_profile_filled, unless: :devise_controller?

  private

  def user_profile_filled
    missing_fields = current_user.missing_required_fields
    return if missing_fields.blank?

    render json: { errors: "#{missing_fields.join(', ')} fields are required" },
           status: :unprocessable_entity
  end
end
