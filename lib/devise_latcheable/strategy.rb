require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class Latcheable < Authenticatable
      def authenticate!
        resource = mapping.to.find_by(authentication_hash)

        if resource && validate(resource) { resource.latch_unlocked? }
          if ::DeviseLatcheable.config['latch_only'] == true
            success! resource
          else
            pass
          end
        else
          fail 'Latch is locked. Unlock and try again.'
        end
      end
    end
  end
end

Warden::Strategies.add :latcheable, Devise::Strategies::Latcheable
