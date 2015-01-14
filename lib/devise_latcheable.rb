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

require 'latchsdk'
require 'devise'
require 'devise_latcheable/model'
require 'devise_latcheable/strategy'
require 'devise_latcheable/engine'

module DeviseLatcheable
  # The config file
  mattr_accessor :config

  # We instantiate only one api client per app
  mattr_accessor :api
  
  def self.initialize
    self.config = YAML.load(File.read('config/latch.yml'))

    self.api = ::Latch.new ::DeviseLatcheable.config['app_id'],
                           ::DeviseLatcheable.config['app_secret']
  end
end

Devise.add_module :latcheable,
                  route: :session, strategy: true,
                  controller: :sessions, model: 'devise_latcheable/model'
