# frozen_string_literal: true

module ResponseHelper
  def json
    JSON.parse(response.body)
  end
end
