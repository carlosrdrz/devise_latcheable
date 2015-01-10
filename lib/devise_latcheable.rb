require 'devise'
require 'devise_latcheable/adapter'
require 'devise_latcheable/model'
require 'devise_latcheable/strategy'
require 'devise_latcheable/engine'

require 'generators/devise_latcheable_generator'

module DeviseLatcheable
end

Devise.add_module :latcheable,
                  route: :session, strategy: true,
                  controller: :sessions, model: 'devise_latcheable/model'
