require 'json'

module Riskified
  class Response

    EXPECTED_ORDER_STATUSES = %w(approved declined).freeze

    def initialize(response)
      validate_response_type(response)

      @response = response
      parse_json
    end

    # Read the status string from the parsed response and convert it to status object (the risk decision).
    def extract_order_status
      validate_code_is_200

      begin
        build_status_object(@parsed_response['order']['status'].downcase)
      rescue StandardError => e
        raise Riskified::Exceptions::UnexpectedOrderStatus.new("Unable to extract order status from response: #{e.message}")
      end
    end

    private

    # Raise an exception if the 'response_code' code is different than 200.
    def validate_code_is_200
      raise Riskified::Exceptions::RequestFailed.new "Request Failed. Code: #{@response.code}. Message: #{@response.status_message}." if @response.code != 200
    end

    # Parse the JSON response body.
    def parse_json
      begin
        @parsed_response = JSON.parse(@response.body)
      rescue StandardError => e
        raise Riskified::Exceptions::ResponseParsingFailed.new("Unable to to parse JSON response: #{e.message}")
      end
    end

    # Initialize status object from the 'order_status' string.
    def build_status_object(order_status)
      validate_order_status(order_status)

      Object.const_get("Riskified::Statuses::#{order_status.capitalize}").new
    end

    # Raise an exception if the the 'order_status' is unexpected.
    def validate_order_status(order_status)
      raise Riskified::Exceptions::UnexpectedOrderStatus.new "Unexpected Order Status: #{order_status}." if EXPECTED_ORDER_STATUSES.include? order_status === false
    end

    def validate_response_type(response)
      raise ArgumentError('Invalid Response Type.') unless response.is_a?(Typhoeus::Response)
    end

  end
end
