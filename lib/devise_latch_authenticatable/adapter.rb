require_relative 'latch_sdk/Latch'

module Devise
  module Latch
    @latch_instance = Latch.new latch_opts[:app_id], latch_opts[:app_secret]

    # => Pairs an user with the server.
    #    @returns Account ID on success and nil on failure
    def self.pair(code)
      res = @latch_instance.pair code
      return nil if res.data.nil?
      res.data['accountId']
    end

    def self.unlocked?(accountId)
      res = @latch_instance.status accountId
      return true if res.error.nil?
      
      key = res.data['operations'].keys.first
      status = res.data['operations'][key]['status']
      status == 'on'
    end
  end
end