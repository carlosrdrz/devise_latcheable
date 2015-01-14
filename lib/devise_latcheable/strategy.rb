# devise_latcheable: latch implementation for rails and devise
# Copyright (C) 2015 Carlos Rodriguez
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

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
