module Devise
  module Models
    module Latcheable
      extend ActiveSupport::Concern

      included do
        # We only use pair code to pair the user with latch. Once it is
        # paired, we dont need the pair code anymore, so we wont save
        # it on the database
        attr_accessor :pair_code

        after_initialize :latch_enable

        before_create :latch_pair!
        before_destroy :latch_unpair!
      end

      def latch_enabled?
        latch_enabled
      end

      def latch_unlocked?
        return true unless latch_enabled?
        return false if latch_account_id.nil?
        Devise::Latch.unlocked? latch_account_id
      end

      def latch_unpair!
        return true unless latch_enabled?
        return false if latch_account_id.nil?
        Devise::Latch.unpair latch_account_id
      end

      def latch_pair!
        return true unless latch_enabled?

        self.latch_account_id = Devise::Latch.pair pair_code

        if latch_account_id.nil?
          errors.add(:base, 'Invalid latch pair code')
          return false
        end
      end

      def latch_enable
        latch_enabled = true if Devise::Latch.config['always_enabled'] == true
      end
    end
  end
end
