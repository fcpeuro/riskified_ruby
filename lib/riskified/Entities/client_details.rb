# frozen_string_literal: true

module Riskified
  module Entities

    ## Reference: https://apiref.riskified.com/curl/#models-client-details
    ClientDetails = KeywordStruct.new(

        #### Optional #####

        :accept_language,
        :user_agent,
    )

  end
end
