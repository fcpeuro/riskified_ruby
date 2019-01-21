require "typhoeus"
require "openssl"
require 'json'

require 'riskified/configuration'

module Riskified
  class Client
    
    SANDBOX_URL = "https://sandbox.riskified.com".freeze
    LIVE_URL = "https://wh.riskified.com".freeze
    
    def checkout_create(body)
      post_request("/api/checkout_create", body)
    end
    
    def create(body)
      post_request("/api/create", body)
    end  
    
    def update(body)
      post_request("/api/update", body)
    end
    
    def checkout_denied(body)
      post_request("/api/checkout_denied", body)
    end  
    
    def cancel(body)
      post_request("/api/cancel", body)
    end
    
    def refund(body)
      post_request("/api/refund", body)  
    end    

    private
    
    def base_url
      Riskified.config.sandbox_mode == true ? SANDBOX_URL : LIVE_URL
    end
    
    def calc_hmac(body)
      OpenSSL::HMAC.hexdigest('SHA256', Riskified.config.auth_token, body)
    end
    
    def post_request(endpoint, body)
      formatted_body = body.to_json
      
      request = Typhoeus::Request.new(
        (base_url + endpoint),
        method: :post,
        body: formatted_body,
        headers: {
          "Content-Type": "application/json",
          "ACCEPT": "application/vnd.riskified.com; version=2",
          "X-RISKIFIED-SHOP-DOMAIN": Riskified.config.shop_domain,
          "X-RISKIFIED-HMAC-SHA256": calc_hmac(formatted_body)
        }
      )
      # This is a callback for when the request finishes. It needs to be defined before running the actual request is run.
      handle_response(request)
      
      request.run
    end
    
    def handle_response(request)
      request.on_complete do |response|
        if response.success?
          
        elsif response.timed_out?
          
        elsif response.code == 0
          # Could not get an http response, something's wrong.
          # log(response.return_message)
        else
          # Received a non-successful http response.
          # log("HTTP request failed: " + response.code.to_s)
        end
      end
    end
    
  end
end
