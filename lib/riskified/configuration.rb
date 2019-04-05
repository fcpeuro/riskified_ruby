module Riskified
  class Configuration
    attr_accessor :sandbox_mode, :sync_mode, :auth_token, :default_referrer, :shop_domain

    def initialize
      @sync_mode = true # set by default.
      @sandbox_mode = nil
      @auth_token = nil
      @default_referrer = nil
      @shop_domain = nil
    end

    def validate
      raise Exception.new('The "RISKIFIED_AUTH_TOKEN" is not found.') if @auth_token.nil? || @auth_token.empty?
      raise Exception.new('The "RISKIFIED_SHOP_DOMAIN" is not found.') if @shop_domain.nil? || @shop_domain.empty?
    end

  end
end
