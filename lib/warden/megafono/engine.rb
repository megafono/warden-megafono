# frozen_string_literal: true

require 'warden/megafono/strategies/id.rb'

module Warden
  module Megafono
    class Engine < ::Rails::Engine
      isolate_namespace Warden::Megafono

      initializer 'megafono.warden' do |app|
        if Rails.env.development?
          require 'openssl'
          OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
        end

        Warden::Manager.after_authentication do |_user, auth, opts|
          scope = opts.fetch(:scope)
          strategy = auth.winning_strategies[scope]
          strategy.finalize_flow! if strategy.class == Warden::Megafono::Strategies::Id
        end

        app.middleware.use Warden::Manager do |config|
          config.strategies.add :id, Warden::Megafono::Strategies::Id
          # config.failure_app = Cockpit::OAuth2::FailureApp

          config.scope_defaults :producer, strategies: [:id]

          config.serialize_into_session(:producer) do |producer|
            { id: producer.id }
          end

          config.serialize_from_session(:producer) do |data|
            Warden::Megafono::Producer.find(data['id'])
          end
        end
      end
    end
  end
end