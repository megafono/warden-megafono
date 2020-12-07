# frozen_string_literal: true

module Warden
  module Megafono
    class Producer < ApplicationRecord
      self.table_name = 'users'

      def self.from_auth(client)
        me = client.get('/me').parsed
        find(me['id'])
      end
    end
  end
end