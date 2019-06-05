# frozen_string_literal: true

module Riskified
  module Entities

    ## Reference: https://apiref.riskified.com/curl/#models-payment-details
    PaypalDetails = Riskified::Entities::KeywordStruct.new(

        ##### Required #####

        :payer_email,
        :payer_status,
        :payer_address_status,
        :protection_eligibility,

        #### Optional #####

        :payment_status,
        :pending_reason,
        :authorization_id,
        :authorization_error, # [AuthorizationError]
    )
  end
end
