# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  respond_to :json
  before_action :authenticate_user!
  before_action :require_user_fields, unless: :devise_controller?

  private

  def require_user_fields
    missing_fields = current_user.missing_require_fields
    return if missing_fields.blank?

    render json: { errors: "#{missing_fields.join(', ')} fields are required" },
           status: :unprocessable_entity
  end
end
