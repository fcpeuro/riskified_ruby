module Riskified
  class Configuration
    attr_accessor :sandbox_mode, :auth_token,:default_referrer

    def initialize
      @sandbox_mode = nil
      @auth_token = nil
      @default_referrer = nil
    end
    
  end
end
