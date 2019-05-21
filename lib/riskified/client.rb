require 'riskified/configuration'

module Riskified
  class Client

    # Call the '/decide' endpoint.
    # @param riskified_order [Riskified::Entities::Order] Order information.
    # @return [Riskified::Response]
    def decide(riskified_order)
      make_request("/api/decide", riskified_order)
    end

    private

    # Make an HTTP post request to the Riskified API.
    def make_request(resource, riskified_order)
      validate_riskified_order_type(riskified_order)

      Riskified.validate_configuration

      response = Riskified::Request.new(
          resource,
          riskified_order.convert_to_json
      ).send
    end

    # Raise error if riskified_order in not of type Riskified::Entities::Order
    def validate_riskified_order_type(riskified_order)
      raise ArgumentError('Invalid Riskified Order Type.') unless riskified_order.is_a?(Riskified::Entities::Order)
    end

  end
end
