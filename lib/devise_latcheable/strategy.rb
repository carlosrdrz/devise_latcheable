require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class Latcheable < Authenticatable
      def authenticate!
        resource = mapping.to.new
        binding.pry

        if resource && validate(resource) { resource.unlocked? }
          success! resource
        else
          fail :invalid
        end
      end
    end
  end
end

Warden::Strategies.add :latcheable, Devise::Strategies::Latcheable
