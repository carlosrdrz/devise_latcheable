module Devise
  module Models
    module Latcheable
      extend ActiveSupport::Concern

      included do
        # We only use pair code to pair the user with latch. Once it is
        # paired, we dont need the pair code anymore, so we wont save
        # it on the database
        attr_accessor :pair_code

        before_create :latch_pair
      end

      def latch_unlocked?
        return false if latch_account_id.nil?
        Devise::Latch.unlocked? latch_account_id
      end

      private

      def latch_pair        
        self.latch_account_id = Devise::Latch.pair pair_code

        if latch_account_id.nil?
          errors.add(:base, 'Invalid latch pair code')
          return false
        end
      end
    end
  end
end
