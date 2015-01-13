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
