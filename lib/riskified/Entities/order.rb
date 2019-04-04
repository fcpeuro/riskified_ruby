# frozen_string_literal: true

module Riskified
  module Entities

    ## Reference: https://apiref.riskified.com/curl/#models-order
    Order = KeywordStruct.new(

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
        :shipping_address, # Address
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
        :decision, # DecisionDetails
        :charge_free_payment_details, # ChargeFreePaymentDetails
        :cancel_reason, # (customer, fraud, inventory, other)
        :submission_reason, # (failed_verification, rule_decision, third_party, manual_decision, policy_decision)
    ) do

      def to_json
        {order: self}.to_json
      end

    end

  end
end
