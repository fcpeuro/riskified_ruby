# frozen_string_literal: true

module Riskified
	module Entities

		## Reference: https://apiref.riskified.com/curl/#models-order
		Order = Riskified::Entities::KeywordStruct.new(

			##### Required #####

			:id,
			:email,
			:created_at,
			:currency,
			:gateway,
			:browser_ip,
			:total_price,
			:total_discounts,
			:referring_site,
			:customer, # Customer
			:client_details, # ClientDetails
			:billing_address, # Address
			:line_items, # [LineItem]
			:discount_codes, # [DiscountCode]
			:shipping_lines, # [ShippingLines]
			:source, # (desktop_web, mobile_web, mobile_app, web, chat, third_party, phone, in_store, shopify_draft_order, unknown)

			#### Optional #####

			:checkout_id,
			:vendor_id,
			:vendor_name,
			:order_type,
			:name,
			:updated_at,
			:cart_token,
			:note,
			:payment_details, # [PaymentDetails]
			:passengers, # [Passenger]
			:charge_free_payment_details, # ChargeFreePaymentDetails
			:decision, # DecisionDetails
			:cancel_reason, # (customer, fraud, inventory, other)
			:submission_reason, # (failed_verification, rule_decision, third_party, manual_decision, policy_decision)
		) do

			def convert_to_json
				order = self.to_h

				order[:customer] = order[:customer].to_h
				order[:client_details] = order[:client_details].to_h
				# order[:decision] = order[:decision].to_h
				# order[:billing_address] = order[:billing_address].to_h
				# order[:charge_free_payment_details] = order[:charge_free_payment_details].to_h

				line_items = Array.new
				order[:line_items]&.each {|i| line_items.push i.to_h}
				order[:line_items] = line_items

				discount_codes = Array.new
				order[:discount_codes]&.each {|i| discount_codes.push i.to_h}
				order[:discount_codes] = discount_codes

				shipping_lines = Array.new
				order[:shipping_lines]&.each {|i| shipping_lines.push i.to_h}
				order[:shipping_lines] = shipping_lines

				payment_details = Array.new
				order[:payment_details]&.each {|i| payment_details.push i.to_h}
				order[:payment_details] = payment_details

				# passengers = Array.new
				# order[:passengers]&.each {|i| passengers.push i.to_h}
				# order[:passengers] = passengers

				{order: order}.to_json

			end

		end
	end
end
