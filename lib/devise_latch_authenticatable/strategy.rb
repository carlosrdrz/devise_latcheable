require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class LatchAuthenticatable < Authenticatable
      def authenticate!
        resource = mapping.to.new

        if resource && validate(resource) { resource.unlocked? }
          success! resource
        else
          fail :invalid
        end
      end
    end
  end
end

Warden::Strategies.add :latch_authenticatable, Devise::Strategies::LatchAuthenticatable