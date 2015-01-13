module Devise
  module Models
    module Latcheable
      extend ActiveSupport::Concern

      included do
        # We only use pair code to pair the user with latch. Once it is
        # paired, we dont need the pair code anymore, so we wont save
        # it on the database
        attr_accessor :latch_pair_code

        after_initialize :latch_enable

        before_create :latch_pair!
        before_destroy :latch_unpair!
      end

      def latch_enabled?
        latch_enabled
      end

      # => Checks if the app lock is open
      #    @returns true if the latch is unlocked
      #    @returns false if the latch is locked or if there was an error
      def latch_unlocked?
        return true unless latch_enabled?
        return false if latch_account_id.nil?
        ::DeviseLatcheable.initialize if ::DeviseLatcheable.api.nil?
        api_response = ::DeviseLatcheable.api.status latch_account_id

        if api_response.error.nil?
          key = api_response.data['operations'].keys.first
          status = api_response.data['operations'][key]['status']
          return (status == 'on')
        else
          return false
        end
      end

      # => Removes the pairing from latch
      #    If an error occurs, it copies the error at errors base
      #    so you can access it with model_instance.errors
      #    @returns true on success, false otherwise
      def latch_unpair!
        return true unless latch_enabled?
        return true if latch_account_id.nil?
        ::DeviseLatcheable.initialize if ::DeviseLatcheable.api.nil?
        api_response = ::DeviseLatcheable.api.unpair latch_account_id

        if api_response.error.nil?
          return true
        else
          errors.add(:base, "Latch error: #{api_response.error.message}")
          return false
        end
      end

      # => Pairs an user with the server.
      #    If an error occurs, it copies the error at errors base
      #    so you can access it with model_instance.errors
      #    On success, it sets latch_account_id to the value that
      #    latch server sent on its response
      #    @returns true on success, false otherwise
      def latch_pair!
        return true unless latch_enabled?
        ::DeviseLatcheable.initialize if ::DeviseLatcheable.api.nil?
        api_response = ::DeviseLatcheable.api.pair latch_pair_code
        
        if api_response.error.nil?
          self.latch_account_id = api_response.data['accountId']
          return true
        else
          errors.add(:base, "Latch error: #{api_response.error.message}")
          return false
        end
      end

      def latch_enable 
        ::DeviseLatcheable.initialize if ::DeviseLatcheable.config.nil?
        if ::DeviseLatcheable.config['always_enabled'] == true
          self.latch_enabled = true
        end
      end
    end
  end
end
