# frozen_string_literal: true

module Warden
  module Megafono
    module AuthenticationHelper
      extend ActiveSupport::Concern

      included do
        helper_method :current_producer, :user_signed?
      end

      def authenticate!
        warden.authenticate!(:id, scope: :producer)
      end

      def current_producer
        warden.user(scope: :producer)
      end

      def user_signed?
        warden.authenticated?(:id, scope: :producer)
      end

      def warden
        request.env['warden']
      end
    end
  end
end