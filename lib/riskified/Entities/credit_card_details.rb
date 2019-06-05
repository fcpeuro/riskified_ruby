# frozen_string_literal: true

module Riskified
  module Entities

    ## Reference: https://apiref.riskified.com/curl/#models-payment-details
    CreditCardDetails = Riskified::Entities::KeywordStruct.new(

        ##### Required #####

        :credit_card_bin,
        :avs_result_code,
        :cvv_result_code,
        :credit_card_number,
        :credit_card_company,

        #### Optional #####

        :authorization_id,
        :authorization_error,
    )
  end
end
