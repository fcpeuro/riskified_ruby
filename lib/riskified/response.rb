require 'json'

module Riskified
  class Response

    EXPECTED_ORDER_STATUSES = %w(approved declined).freeze

    def initialize(response, request_body = '')
      validate_response_type(response)

      @response = response
      @request_body = request_body

      parse_response_body
    end


    # Read the status string from the parsed response and convert it to status object (the risk decision).
    def status
      begin
        status = @parsed_response['order']['status'].downcase
        validate_order_status(status)
        return status
      rescue StandardError => e
        raise Riskified::Exceptions::UnexpectedOrderStatusError.new("Invalid order status in response [#{@parsed_response}]. Error Message #{e.message}.")
      end
    end

    # Read the status string from the parsed response and convert it to status object (the risk decision).
    def description
      @parsed_response['order']['description']
    end

    def body
      @parsed_response
    end

    def code
      @response.code
    end

    def message
      @response.status_message
    end

    private

    # Parse the JSON response body.
    def parse_response_body
      begin
        @parsed_response = @response.body.empty? === false ? JSON.parse(@response.body) : ''
      rescue StandardError => e
        raise Riskified::Exceptions::ResponseParsingError.new("Unable to to parse JSON response '#{@parsed_response}'. Error Message: '#{e.message}'.")
      end
    end

    # Raise an exception if the the 'order_status' is unexpected.
    def validate_order_status(order_status)
      raise Riskified::Exceptions::UnexpectedOrderStatusError.new("Unexpected Order Status: '#{order_status}'.") unless EXPECTED_ORDER_STATUSES.include? order_status
    end

    def validate_response_type(response)
      raise ArgumentError('Invalid Response Type.') unless response.is_a?(Typhoeus::Response)
    end

  end
end
