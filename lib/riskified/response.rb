require 'json'

module Riskified
  class Response

    EXPECTED_ORDER_STATUSES = %w(approved declined).freeze

    def initialize(response, request_body = '')
      validate_response_type(response)

      @response = response
      @request_body = request_body

      parse_json
    end

    # Read the status string from the parsed response and convert it to status object (the risk decision).
    def extract_order_status
      validate_code_is_200

      begin
        status = @parsed_response['order']['status'].downcase
      rescue StandardError => e
        raise Riskified::Exceptions::UnexpectedOrderStatusError.new("Unable to extract order status from response. Error Message #{e.message}. Response Body: #{@response.body}. Request Body: #{@request_body}.")
      end

      build_status_object(status)
    end

    private

    # Raise an exception if the 'response_code' code is different than 200.
    def validate_code_is_200
      raise Riskified::Exceptions::RequestFailedError.new "Request Failed. Response Code: #{@response.code}. Response Message: #{@response.status_message}. Request Body: #{@request_body}." if @response.code != 200
    end

    # Parse the JSON response body.
    def parse_json
      begin
        @parsed_response = JSON.parse(@response.body)
      rescue StandardError => e
        raise Riskified::Exceptions::ResponseParsingError.new("Unable to to parse JSON response. Error Message: #{e.message}. Response Body: #{@response.body}. Request Body: #{@request_body}.")
      end
    end

    # Initialize status object from the 'order_status' string.
    def build_status_object(order_status)
      validate_order_status(order_status)

      Object.const_get("Riskified::Statuses::#{order_status.capitalize}").new
    end

    # Raise an exception if the the 'order_status' is unexpected.
    def validate_order_status(order_status)
      raise Riskified::Exceptions::UnexpectedOrderStatusError.new "Unexpected Order Status: #{order_status}. Response Body: #{@response.body}. Request Body: #{@request_body}." unless EXPECTED_ORDER_STATUSES.include? order_status
    end

    def validate_response_type(response)
      raise ArgumentError('Invalid Response Type.') unless response.is_a?(Typhoeus::Response)
    end

  end
end
