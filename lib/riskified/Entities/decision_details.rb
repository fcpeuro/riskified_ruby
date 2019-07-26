# frozen_string_literal: true

module Riskified
  module Entities

    ## Reference: http://apiref.riskified.com/java/#models-decision-details
    DecisionDetails = Riskified::Entities::KeywordStruct.new(

        ##### Required #####

        :external_status, # string
        :decided_at, # DateTime

        #### Optional #####

        :reason, # string
        :amount, # float
        :currency, # string
        :notes, # string
    )

  end
end
