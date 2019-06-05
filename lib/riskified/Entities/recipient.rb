# frozen_string_literal: true

module Riskified
  module Entities

    ## Reference: https://apiref.riskified.com/curl/#models-recipient
    Recipient = Riskified::Entities::KeywordStruct.new(

        ##### Required #####

        #### Optional #####

        :email,
        :phone,
        :social, # [Social]
    )

  end
end
