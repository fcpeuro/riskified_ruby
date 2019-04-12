module Riskified
  class Configuration
    attr_accessor :sandbox_mode, :sync_mode, :auth_token, :default_referrer, :shop_domain

    def initialize
      @sync_mode = true # is set by default.
      @sandbox_mode = nil
      @auth_token = nil
      @default_referrer = nil
      @shop_domain = nil
    end

    def validate
      raise ConfigurationError.new('The "Auth Token" configuration is not found.') if @auth_token.nil? || @auth_token.empty?
      raise ConfigurationError.new('The "Shop Domain" configuration is not found.') if @shop_domain.nil? || @shop_domain.empty?
      raise ConfigurationError.new('The "Default Referrer" configuration is not found.') if @default_referrer.nil? || @default_referrer.empty?
    end

  end
end
