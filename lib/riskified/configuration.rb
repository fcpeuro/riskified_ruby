module Riskified
  class Configuration
    attr_accessor :sandbox_mode, :sync_mode, :auth_token, :default_referrer, :default_shop_domain

    def initialize
      @sync_mode = true # set by default.
      @sandbox_mode = nil
      @auth_token = nil
      @default_referrer = nil
      @default_shop_domain = nil
    end

    def validate
      raise Exception.new('The "RISKIFIED_AUTH_TOKEN" is not found.') if @auth_token.nil? || @auth_token.empty?
    end

  end
end
