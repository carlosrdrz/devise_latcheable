module Devise
  module Latch
    @yaml_config = YAML.load(File.read("config/latch.yml"))
    @latch_instance = ::Latch::Latch.new @yaml_config['app_id'], @yaml_config['app_secret']

    # => Pairs an user with the server.
    #    @returns Account ID on success and nil on failure
    def self.pair(code)
      res = @latch_instance.pair code
      return nil if res.data.nil?
      res.data['accountId']
    end

    # => Checks if the app lock is open
    def self.unlocked?(account_id)
      res = @latch_instance.status account_id
      return false unless res.error.nil?
      
      key = res.data['operations'].keys.first
      status = res.data['operations'][key]['status']
      status == 'on'
    end

    # => Removes the pairing from lath
    def self.unpair(account_id)
      res = @latch_instance.unpair account_id
      res.error.nil? ? true : false
    end

    def self.config
      @yaml_config
    end
  end
end