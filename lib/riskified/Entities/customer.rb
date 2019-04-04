# frozen_string_literal: true

module Riskified
  module Entities

    ## Reference: https://apiref.riskified.com/curl/#models-customer
    Customer = KeywordStruct.new(

        ##### Required #####

        :email,
        :verified_email,
        :first_name,
        :last_name,
        :id,
        :created_at,

        #### Optional #####

        :social, # [Social]
        :verified_email_at,
        :first_purchase_at,
        :orders_count,
        :account_type,
        :phone,
        :verified_phone,
        :verified_phone_at,
        :date_of_birth,
        :user_name,
        :phone_mandatory,
        :referrer_customer_id,
        :social_signup_type, # (facebook, google, linkedin, twitter, yahoo, other)
        :gender, # (Male, Female)
    )

  end
end
