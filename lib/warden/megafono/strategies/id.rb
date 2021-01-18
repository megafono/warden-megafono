# frozen_string_literal: true

require 'warden'
require 'oauth2'

module Warden
  module Megafono
    module Strategies
      class Id < ::Warden::Strategies::Base
        SESSION_KEY = 'megafono-id'

        def valid?
          params.fetch('host', 'cockpit').split('.').first != 'id'
        end

        def authenticate!
          if in_flow?
            continue_flow!
          else
            begin_flow!
          end
        end

        def finalize_flow!
          redirect!(custom_session['return_to'])
          teardown_flow
          throw(:warden)
        end

        private

        def in_flow?
          !custom_session.empty? &&
            params['state'] &&
            (params['code'] || params['error'])
        end

        def continue_flow!
          validate_flow!
          get_token!(params['code'])
          load_user!
        end

        def begin_flow!
          custom_session['state'] = state
          custom_session['return_to'] = request.url

          redirect!(authorize_url)
        end

        def validate_flow!
          if params['state'] != state
            abort_flow!('State mismatch')
          elsif (error = params['error']) && error.present?
            abort_flow!(error.tr('_', ' '))
          end
        end

        def get_token!(code)
          @token ||= oauth.auth_code.get_token(code, redirect_uri: redirect_uri)
        rescue ::OAuth2::Error => e
          abort_flow!(e)
        end

        def load_user!
          success!(Warden::Megafono::Producer.from_auth(@token))
        end

        def abort_flow!(message)
          teardown_flow
          fail!(message)
          throw(:warden)
        end

        def teardown_flow
          session.delete(SESSION_KEY)
        end

        def state
          @state ||= custom_session['state'] || SecureRandom.hex(20)
        end

        def custom_session
          session[SESSION_KEY] ||= {}
        end

        def authorize_url
          oauth.auth_code.authorize_url(
            redirect_uri: redirect_uri,
            state: state
          )
        end

        def redirect_uri
          "#{protocol}://#{::Megafono::Domain.('cockpit')}"
        end

        def oauth
          @oauth ||= ::OAuth2::Client.new(
            Warden::Megafono.configuration.client_id,
            Warden::Megafono.configuration.client_secret,
            site: "#{protocol}://#{::Megafono::Domain.('id')}/",
            authorize_url: '/oauth/authorize',
            token_url: '/oauth/token'
          )
        end

        def protocol
          ::Megafono::Domain.protocol
        end
      end
    end
  end
end
