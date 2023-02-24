# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  respond_to :json
  before_action :authenticate_user!
  before_action :require_user_fields, unless: :devise_controller?

  private

  def require_user_fields
    user = current_user
    missing_fileds = %i[name birthdate username].select do |field|
      user.send(field).blank?
    end
    return if missing_fileds.blank?

    render json: { errors: "#{missing_fileds.join(', ')} fields are required" },
           status: :unprocessable_entity
  end
end
