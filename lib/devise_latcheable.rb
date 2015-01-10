require 'devise'
require 'devise_latcheable/adapter'
require 'devise_latcheable/model'
require 'devise_latcheable/strategy'

module Devise
end

Devise.add_module :latcheable,
                  route: :session, strategy: true,
                  controller: :sessions, model: 'devise_latcheable/model'
