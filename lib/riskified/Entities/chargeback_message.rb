# frozen_string_literal: true

module Riskified
  module Entities

    ## Reference: http://apiref.riskified.com/java/#models-chargeback-details
    ChargebackMessage = Riskified::Entities::KeywordStruct.new(
      :id, # order id
      :chargeback_details, # ChargebackDetails
      :dispute_details # DisputeDetails
    ) do

      def convert_to_json
        order = self.to_h
        {order: order}.to_json
      end
    end
  end
end
