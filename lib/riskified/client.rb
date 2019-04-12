require "typhoeus"
require "openssl"
require 'riskified/configuration'

module Riskified
  class Client


    # Call the '/decide' endpoint.
    # @param riskified_order [Riskified::Entities::Order] Order information.
    # @return [Approved | Declined]
    def decide(riskified_order)
      make_request("/api/decide", riskified_order)
    end

    private

    # Make an HTTP post request to the Riskified API.
    def make_request(resource, riskified_order)
      Riskified.validate_configuration

      response = Riskified::Request.new(
          resource,
          riskified_order.convert_to_json
      ).send

      # returns the Order Status Object
      response.extract_order_status
    end


  end
end
