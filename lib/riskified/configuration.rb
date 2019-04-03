module Riskified
  class Configuration
    attr_accessor :sandbox_mode, :auth_token, :default_referrer, :shop_domain

    def initialize
      @sandbox_mode = nil
      @auth_token = nil
      @default_referrer = nil
      @shop_domain = nil
    end

    def validate
      raise Exception.new('The "RISKIFIED_AUTH_TOKEN" environment variable is not found.') if @auth_token.blank? || @auth_token.nil?
      raise Exception.new('The "RISKIFIED_SHOP_DOMAIN" environment variable is not found.') if @shop_domain.blank? || @shop_domain.nil?
    end

  end
end
