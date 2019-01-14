module Riskified
  class Configuration
    attr_accessor :sandbox_mode, :auth_token, :default_referrer, :shop_domain

    def initialize
      @sandbox_mode = nil
      @auth_token = nil
      @default_referrer = nil
      @shop_domain = nil
    end
    
  end
end
