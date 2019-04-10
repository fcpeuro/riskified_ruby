require "typhoeus"
require "openssl"
require 'json'
require 'riskified/configuration'

module Riskified
  class Client

    SANDBOX_URL = "https://sandbox.riskified.com".freeze
    ASYNC_LIVE_URL = "https://wh.riskified.com".freeze
    SYNC_LIVE_URL = "https://wh-sync.riskified.com".freeze
    EXPECTED_ORDER_STATUSES = %w(approved declined).freeze

    def initialize
      Riskified.validate_configuration
    end

    # Call the '/decide' endpoint.
    # @param riskified_order [Riskified::Entities::Order] Order information.
    # @param shop_domain [string | nil] the full domain name of shop that was registered.
    # @return [Approved | Declined]
    def decide(riskified_order, shop_domain = nil)
      post_request("/api/decide", riskified_order, shop_domain)
    end

    private

    # Make an HTTP post request to the Riskified API.
    def post_request(endpoint, riskified_order, shop_domain)
      json_formatted_body = riskified_order.convert_to_json
      hmac = calculate_hmac_sha256(json_formatted_body)
      shop_domain = shop_domain(shop_domain)

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

      validate_response_code(response.code, response.status_message)

      parsed_response = parse_json_response(response.body)

      extract_order_status(parsed_response)
    end

    # Read the status string from the parsed response and convert it to status object (the risk decision). 
    def extract_order_status(parsed_response)
      begin
        order_status = parsed_response['order']['status'].downcase

        validate_order_status(order_status)

        build_status_object(order_status)
      rescue StandardError => e
        raise Riskified::Exceptions::UnexpectedOrderStatus.new("Unable to extract order status from response: #{e.message}")
      end
    end

    # Initialize status object from the 'order_status' string.
    def build_status_object(order_status)
      Object.const_get("Riskified::Statuses::#{order_status.capitalize}").new
    end

    # Parse the JSON response body.
    def parse_json_response(response_body)
      begin
        JSON.parse(response_body)
      rescue StandardError => e
        raise Riskified::Exceptions::ResponseParsingFailed.new("Unable to to parse JSON response: #{e.message}")
      end
    end

    # Raise an exception if the the 'order_status' is unexpected.
    def validate_order_status(order_status)
      raise Riskified::Exceptions::UnexpectedOrderStatus.new "Unexpected Order Status: #{order_status}." if EXPECTED_ORDER_STATUSES.include? order_status === false
    end

    # Raise an exception if the 'response_code' code is different than 200.
    def validate_response_code(response_code, response_status_message)
      raise Riskified::Exceptions::RequestFailed.new "Request Failed. Code: #{response_code}. Message: #{response_status_message}." if response_code != 200
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

    # Return default shop domain if not provided as parameter.
    def shop_domain(shop_domain)
      shop_domain.nil? ? Riskified.config.default_shop_domain : shop_domain
    end

  end
end
