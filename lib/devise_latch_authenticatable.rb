require 'devise'

require 'devise_latch_authenticable/adapter'

module Devise
  mattr_accessor :latch_config
  @latch_config = "#{Rails.root}/config/latch.yml"
end

Devise.add_module :latch_authenticable,
                  route: :session, strategy: true, controller: :sessions,
                  model: 'devise_latch_authenticable/model'
