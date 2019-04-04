require "typhoeus"
require "openssl"
require 'json'

require 'riskified/configuration'

module Riskified
  class Client

    SANDBOX_URL = "https://sandbox.riskified.com".freeze
    LIVE_URL = "https://wh.riskified.com".freeze

    EXPECTED_ORDER_STATUSES = %w(approved declined).freeze

    def initialize
      Riskified.validate_configuration
    end

    def decide(riskified_order)
      post_request("/api/decide", riskified_order)
    end

    def submit(riskified_order)
      post_request("/api/submit", riskified_order)
    end

    def checkout_create(riskified_order)
      post_request("/api/checkout_create", riskified_order)
    end

    def create(riskified_order)
      post_request("/api/create", riskified_order)
    end

    def update(riskified_order)
      post_request("/api/update", riskified_order)
    end

    def checkout_denied(riskified_order)
      post_request("/api/checkout_denied", riskified_order)
    end

    def cancel(riskified_order)
      post_request("/api/cancel", riskified_order)
    end

    def refund(riskified_order)
      post_request("/api/refund", riskified_order)
    end

    def get_response_object
      @response
    end

    private

    def post_request(endpoint, riskified_order)
      json_formatted_body = convert_to_json(riskified_order)

      begin
        # make the HTTP request and get the response object
        @response = Typhoeus::Request.new(
            (base_url + endpoint),
            method: :post,
            body: json_formatted_body,
            headers: headers(json_formatted_body)
        ).run
      rescue StandardError => e
        raise Riskified::Exceptions::ApiConnectionError.new e.message
      end

      validate_response @response

      get_order_status @response
    end

    def get_order_status(response)
      begin
        # parse the JSON response and extract the order status
        order_status = parse_response['order']['status'].downcase

        validate_order_status(order_status)

        build_status_object(order_status)
      rescue StandardError => e
        raise Riskified::Exceptions::ApiConnectionError.new e.message
      end
    end


    def build_status_object(order_status)
      # initialize status object from the string
      "#{order_status.capitalize}".constantize.new
    end

    def parse_response
      JSON.parse(@response.body)
    end

    def validate_order_status(order_status)
      # raise an exception if the the order_status is unexpected
      raise Riskified::Exceptions::UnexpectedOrderStatus.new "Unexpected Order Status: #{order_status}." if EXPECTED_ORDER_STATUSES.include? order_status === false
    end

    def validate_response(response)
      # raise exception if the response code is different than 200
      raise Riskified::Exceptions::ApiConnectionError.new "Response Failed. Code: #{response.code}. Message: #{response.status_message}." if response.code != 200
    end

    def convert_to_json(riskified_order)
      riskified_order.to_json
    end

    def base_url
      Riskified.config.sandbox_mode === true ? SANDBOX_URL : LIVE_URL
    end

    def headers(body)
      {
          "Content-Type": "application/json",
          "ACCEPT": "application/vnd.riskified.com; version=2",
          "X-RISKIFIED-SHOP-DOMAIN": Riskified.config.shop_domain,
          "X-RISKIFIED-HMAC-SHA256": calculate_hmac_sha256(body)
      }
    end

    def calculate_hmac_sha256(body)
      OpenSSL::HMAC.hexdigest('SHA256', Riskified.config.auth_token, body)
    end

  end
end
