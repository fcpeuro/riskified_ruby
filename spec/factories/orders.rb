FactoryBot.define do

  factory :order, class: Riskified::Entities::Order do
    id {rand(111..999)}
    email {'email@samnple.com'}
    created_at {Time.now}
    currency {'USD'}
    gateway {'authorize_net'}
    browser_ip {'111.111.111.111'}
    total_price {26.49}
    total_discounts {0.0}
    referring_site {'cg.nl'}
    source {'web'}
    line_items {
      [
          Riskified::Entities::LineItem.new(
              price: 9.99,
              quantity: 1,
              title: 'Apple Gift Card',
              product_id: 'P123',
              category: 'Cards',
              brand: 'Apple',
          ),
          Riskified::Entities::LineItem.new(
              price: 18.50,
              quantity: 1,
              title: 'Google Gift Card',
              product_id: 'P456',
              category: 'Cards',
              brand: 'Google',
          ),
      ]
      discount_codes {
        [
            Riskified::Entities::DiscountCode.new(
                amount: '2.0',
                code: 'two-two',
            )
        ]
      }
      shipping_lines {
        [
            Riskified::Entities::ShippingLine.new(
                title: 'Free Shipping',
                price: '0.0',
            )
        ]
      }
      customer {
        Riskified::Entities::Customer.new(
            email: email,
            verified_email: true,
            first_name: 'Jone',
            last_name: 'Doe',
            id: 'C123',
            created_at: Time.now,
        )
      }
      client_details {
        Riskified::Entities::ClientDetails.new(
            accept_language: 'en-CA',
            user_agent: 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)',
        )
      }
      billing_address {
        Riskified::Entities::Address.new(
            first_name: 'Jone',
            last_name: 'Doe',
            address1: 'Chestnut Street 92',
            country: 'United States',
            city: 'Louisville',
            zip: '40202',
            phone: '555-625-1199',
        )
      }
    }
  end

end