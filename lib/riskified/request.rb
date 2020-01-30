require "typhoeus"
require "openssl"

module Riskified
  class Request

    SANDBOX_URL = "https://sandbox.riskified.com".freeze
    ASYNC_LIVE_URL = "https://wh.riskified.com".freeze
    SYNC_LIVE_URL = "https://wh-sync.riskified.com".freeze
    CONNECTION_TIMEOUT = 2
    RESPONSE_TIMEOUT = 5

    def initialize(resource, json_body)
      @resource = resource
      @json_body = json_body
      @headers = prepare_headers
    end

    def send
      request = Typhoeus::Request.new(
          endpoint,
          method: :post,
          body: @json_body,
          headers: @headers,
          connecttimeout: CONNECTION_TIMEOUT,
          timeout: RESPONSE_TIMEOUT
      )

      request.on_complete do |response|
        if response.timed_out?
          raise Riskified::Exceptions::RequestTimedOutError.new("Unable to connect. Request was timed out. Total Time: '#{response.total_time}'.")
        elsif response.code == 0
          raise Riskified::Exceptions::ApiConnectionError.new("Unable to connect. Could not get an HTTP response. Response Code: '#{response.code}'.")
        elsif response.code != 200
          raise Riskified::Exceptions::RequestFailedError.new("API request failed. Response Code: '#{response.code}'. Response Message: '#{response.status_message}'. Response Body: '#{response.body}'.")
        end
      end

      Riskified::Response.new(request.run, request)
    end

    def json_body
      @json_body
    end

    def json_headers
      @headers.to_json
    end

    def endpoint
      base_url + @resource
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

    # Build the post request base URL.
    def base_url
      Riskified.config.sandbox_mode ? SANDBOX_URL : live_url
    end

    # Return the live url after checking which flow is configured (sync or async).
    def live_url
      Riskified.config.sync_mode ? SYNC_LIVE_URL : ASYNC_LIVE_URL
    end

  end
end
