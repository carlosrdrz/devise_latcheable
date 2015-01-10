module Devise
  module Models
    module LatchAuthenticatable
      extend ActiveSupport::Concern

      included do
        attr_reader :account_id
      end

      def unlocked?
        Devise::Latch.unlocked accountId
      end
    end
  end
end
