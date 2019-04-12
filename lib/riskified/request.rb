require "typhoeus"
require "openssl"

module Riskified
  class Request

    SANDBOX_URL = "https://sandbox.riskified.com".freeze
    ASYNC_LIVE_URL = "https://wh.riskified.com".freeze
    SYNC_LIVE_URL = "https://wh-sync.riskified.com".freeze

    def initialize(resource, json_body)
      @resource = resource
      @json_body = json_body
    end

    def send
      begin
        response = Typhoeus::Request.new(
            endpoint,
            method: :post,
            body: @json_body,
            headers: prepare_headers
        ).run
      rescue StandardError => e
        raise Riskified::Exceptions::ApiConnectionError.new(e.message)
      end

      Riskified::Response.new(response)
    end

    private

    # Return POST request headers.
    def prepare_headers
      {
          "Content-Type":"application/json",
          "ACCEPT":"application/vnd.riskified.com; version=2",
          "X-RISKIFIED-SHOP-DOMAIN":shop_domain,
          "X-RISKIFIED-HMAC-SHA256":calculate_hmac_sha256,
      }
    end

    # Generate HMAC string from the request body using SHA256.
    def calculate_hmac_sha256
      OpenSSL::HMAC.hexdigest('SHA256', Riskified.config.auth_token, @json_body)
    end

    # Return the configured shop domain.
    def shop_domain
      Riskified.config.shop_domain
    end

    def endpoint
      base_url + @resource
    end

    # Build the post request base URL.
    def base_url
      Riskified.config.sandbox_mode === true ? SANDBOX_URL : live_url
    end

    # Return the live url after checking which flow is configured (sync or async).
    def live_url
      Riskified.config.sync_mode === true ? SYNC_LIVE_URL : ASYNC_LIVE_URL
    end

  end
end
