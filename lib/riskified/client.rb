require 'riskified/configuration'

module Riskified
  class Client

    # Call the '/decide' endpoint.
    # @param order [Riskified::Entities::Order] Order information.
    # @return [Riskified::Response]
    def decide(order)
			raise ArgumentError('Invalid Riskified Order Type.') unless order.is_a?(Riskified::Entities::Order)

      prepare_request("/api/decide", order)
		end

		# Call the '/decision' endpoint.
		# @param decision [Riskified::Entities::Decision] Decision information.
		# @return [Riskified::Response]
		def decision(decision)
			raise ArgumentError('Invalid Riskified Decision Type.') unless decision.is_a?(Riskified::Entities::Decision)

      prepare_request("/api/decision", decision)
    end

    # @return [Riskified::Request]
    def execute
      @request.send
    end

    private

    # Make an HTTP post request to the Riskified API.
    def prepare_request(resource, body)
      Riskified.validate_configuration

      @request = Riskified::Request.new(
          resource,
					body.convert_to_json
      )
    end

  end
end
