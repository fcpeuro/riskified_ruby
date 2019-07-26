# frozen_string_literal: true

module Riskified
	module Entities

		## Reference: http://apiref.riskified.com/java/#actions-decision
		Decision = Riskified::Entities::KeywordStruct.new(

			##### Required #####

			:id,
			:decision_details, # DecisionDetails
		) do

			def convert_to_json
				order = self.to_h

				order[:decision] = order[:decision_details].to_h

				{order: order}.to_json
			end

		end

	end
end
