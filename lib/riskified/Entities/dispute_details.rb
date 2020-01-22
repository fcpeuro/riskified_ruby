# frozen_string_literal: true

module Riskified
  module Entities
    ## Reference: http://apiref.riskified.com/java/#models-dispute-details
    DisputeDetails = Riskified::Entities::KeywordStruct.new(
      :id,
      :case_id,
      :status,
      :dispute_type
    )
  end
end
