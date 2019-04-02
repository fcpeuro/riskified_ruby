require "typhoeus"
require "openssl"
require 'json'

require 'riskified/configuration'

module Riskified
  class Client

    SANDBOX_URL = "https://sandbox.riskified.com".freeze
    LIVE_URL = "https://wh.riskified.com".freeze

    def decide(json_body)
      post_request("/api/decide", json_body)
    end

    def submit(json_body)
      post_request("/api/submit", json_body)
    end

    def checkout_create(json_body)
      post_request("/api/checkout_create", json_body)
    end

    def create(json_body)
      post_request("/api/create", json_body)
    end

    def update(json_body)
      post_request("/api/update", json_body)
    end

    def checkout_denied(json_body)
      post_request("/api/checkout_denied", json_body)
    end

    def cancel(json_body)
      post_request("/api/cancel", json_body)
    end

    def refund(json_body)
      post_request("/api/refund", json_body)
    end

    private

    def post_request(endpoint, json_formatted_body)
      Typhoeus::Request.new(
          (base_url + endpoint),
          method: :post,
          body: json_formatted_body,
          headers: headers(json_formatted_body)
      ).run
    end

    def base_url
      Riskified.config.sandbox_mode === true ? SANDBOX_URL : LIVE_URL
    end

    def headers(body)
      {
          "Content-Type": "application/json",
          "ACCEPT": "application/vnd.riskified.com; version=2",
          "X-RISKIFIED-SHOP-DOMAIN": shop,
          "X-RISKIFIED-HMAC-SHA256": calculate_hmac_sha256(body)
      }
    end

    def shop
      shop = Riskified.config.shop_domain

      raise Exception('The required "shop domain" header is not found.') if shop.nil?

      shop
    end

    def calculate_hmac_sha256(body)
      OpenSSL::HMAC.hexdigest('SHA256', Riskified.config.auth_token, body)
    end

  end
end
