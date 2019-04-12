require "typhoeus"
require "openssl"
require 'riskified/configuration'

module Riskified
  class Client

    SANDBOX_URL = "https://sandbox.riskified.com".freeze
    ASYNC_LIVE_URL = "https://wh.riskified.com".freeze
    SYNC_LIVE_URL = "https://wh-sync.riskified.com".freeze

    # Call the '/decide' endpoint.
    # @param riskified_order [Riskified::Entities::Order] Order information.
    # @return [Approved | Declined]
    def decide(riskified_order)
      post_request("/api/decide", riskified_order)
    end

    private

    # Make an HTTP post request to the Riskified API.
    def post_request(endpoint, riskified_order)
      Riskified.validate_configuration
      json_formatted_body = riskified_order.convert_to_json
      hmac = calculate_hmac_sha256(json_formatted_body)

      begin
        response = Typhoeus::Request.new(
            (base_url + endpoint),
            method: :post,
            body: json_formatted_body,
            headers: headers(hmac, shop_domain)
        ).run
      rescue StandardError => e
        raise Riskified::Exceptions::ApiConnectionError.new(e.message)
      end

      # returns the Order Status Object
      Riskified::Response.new(response).extract_order_status
    end

    # Build the post request base URL.
    def base_url
      live_url = Riskified.config.sync_mode === true ? SYNC_LIVE_URL : ASYNC_LIVE_URL
      Riskified.config.sandbox_mode === true ? SANDBOX_URL : live_url
    end

    # Return POST request headers. 
    def headers(hmac, shop_domain)
      {
          "Content-Type":"application/json",
          "ACCEPT":"application/vnd.riskified.com; version=2",
          "X-RISKIFIED-SHOP-DOMAIN":shop_domain,
          "X-RISKIFIED-HMAC-SHA256":hmac
      }
    end

    # Generate HMAC string from the request body using SHA256.
    def calculate_hmac_sha256(body)
      OpenSSL::HMAC.hexdigest('SHA256', Riskified.config.auth_token, body)
    end

    # Return the configured shop domain
    def shop_domain
      Riskified.config.shop_domain
    end

  end
end
