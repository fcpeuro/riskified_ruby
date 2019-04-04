# frozen_string_literal: true

module Riskified
  module Entities

    ## Reference: https://apiref.riskified.com/curl/#models-address
    Address = KeywordStruct.new(

        ##### Required #####

        :first_name,
        :last_name,
        :address1,
        :country,
        :city,
        :zip,
        :phone,

        #### Optional #####

        :address2,
        :company,
        :province,
        :province_code,
        :country_code,
        :additional_phone,

    )

  end
end
