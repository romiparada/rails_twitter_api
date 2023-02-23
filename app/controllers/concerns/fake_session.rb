# frozen_string_literal: true

module FakeSession
  extend ActiveSupport::Concern

  included do
    before_action :set_fake_rack_session_for_devise

    private

    def set_fake_rack_session_for_devise
      request.env['rack.session'] ||=
        Class.new(Hash) do
          def enabled?
            false
          end
        end.new
    end
  end
end
