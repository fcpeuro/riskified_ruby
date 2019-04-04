# frozen_string_literal: true

module Riskified
  module Entities

    ## Reference: https://apiref.riskified.com/curl/#models-line-item
    LineItem = KeywordStruct.new(# todo: ask: do we need to make   Digital LineItem or the General LineItem is enough?

        ##### Required #####

        :price,
        :quantity,
        :title,
        :product_id,
        :category,
        :brand,
        :product_type, # (physical, digital, travel, event)

        #### Optional #####

        :seller, # [Seller]
        :requires_shippling,
        :sku,
        :size,
        :condition,
        :sub_category,
        :delivered_at,
        :delivered_to, # (shipping_address, store_pickup)
    )

  end
end
