# frozen_string_literal: true

module Riskified
    module Entities
        
        ## Reference: http://apiref.riskified.com/java/#models-chargeback-details
        ChargebackDetails = KeywordStruct.new(
        :id,
        :chargeback_at,
        :chargeback_currency,
        :chargeback_amount,
        :reason_code,
        :type,
        :gateway,
        :reason_description,
        :mid,
        :arn,
        :credit_card_company,
        :respond_by,
        :card_issuer
        )
    end
end
