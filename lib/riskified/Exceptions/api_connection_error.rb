# frozen_string_literal: true

module Riskified
  module Exceptions

    class ApiConnectionError < StandardError
      def initialize(msg = 'Something went wrong while connecting to the Riskified API.')
        super
      end
    end

  end
end