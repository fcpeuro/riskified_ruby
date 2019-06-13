# frozen_string_literal: true

module Riskified
  module Entities

    ## Reference: https://apiref.riskified.com/curl/#models-social
    Social = Riskified::Entities::KeywordStruct.new(

        #### Required #####

        :network,
        :public_username,
        :account_url,
        :id,

        #### Optional #####

        :community_score,
        :profile_picture,
        :email,
        :bio,
        :following,
        :followed,
        :posts,
        :auth_token,
        :social_data
        )

  end
end
