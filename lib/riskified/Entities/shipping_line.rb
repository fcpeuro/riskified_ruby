# frozen_string_literal: true

module Riskified
  module Entities

    ## Reference: https://apiref.riskified.com/curl/#models-shipping-line
    ShippingLine = Riskified::Entities::KeywordStruct.new(

        #### Required #####

        :title,
        :price,

        #### Optional #####

        :code,
        :company,

    )

  end
end
