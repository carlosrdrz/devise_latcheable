require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class Latcheable < Authenticatable
      def authenticate!
        resource = mapping.to.find_by(authentication_hash)

        if resource && validate(resource) { resource.latch_unlocked? }
          success! resource
        else
          fail 'Latch is locked. Remove the lock from you app and try to log in again.'
        end
      end
    end
  end
end

Warden::Strategies.add :latcheable, Devise::Strategies::Latcheable
