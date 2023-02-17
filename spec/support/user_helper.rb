# frozen_string_literal: true

module UserHelper
  def updated_user
    user.reload
  end
end
