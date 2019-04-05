# frozen_string_literal: true

module Riskified
  module Entities

    ## Reference: https://apiref.riskified.com/curl/#models-discount-code
    DiscountCode = Riskified::Entities::KeywordStruct.new(

        #### Required #####

        :amount,
        :code,
    )

  end
end
