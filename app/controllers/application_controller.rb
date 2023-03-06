# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  respond_to :json
  before_action :authenticate_user!
  before_action :user_profile_filled, unless: :devise_controller?

  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def user_profile_filled
    missing_fields = current_user.missing_required_fields
    return if missing_fields.blank?

    render json: { errors: "#{missing_fields.join(', ')} fields are required" },
           status: :unprocessable_entity
  end

  def unprocessable_entity(error)
    errors = error.respond_to?(:record) ? error.record.errors : nil
    render json: { errors: }, status: :unprocessable_entity
  end

  def not_found
    render json: { errors: 'resource could not be found' }, status: :not_found
  end
end
