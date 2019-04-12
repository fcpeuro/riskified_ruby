require 'spec_helper'
require 'securerandom'
require 'byebug'

module Riskified
  describe 'Riskified Client' do

    def configure_riskified
      Riskified.configure do |config|
        config.auth_token = '<SHOP_AUTH_TOKEN_GOES_HERE>' # Note: make sure you never commit your token.
        config.default_referrer = 'www.google.com'
        config.shop_domain = 'www.recharge.com'
        config.sandbox_mode = true
      end
    end

    def build_order(order_id, email)
      Riskified::Entities::Order.new(
          id: order_id,
          email: email,
          created_at: Time.now,
          currency: 'USD',
          gateway: 'authorize_net',
          browser_ip: '111.111.111.111',
          total_price: 26.49,
          total_discounts: 0.0,
          referring_site: 'cg.nl',
          source: 'web',
          line_items: [
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
          ],
          discount_codes: [
              Riskified::Entities::DiscountCode.new(
                  amount: '2.0',
                  code: 'two-two',
              )
          ],
          shipping_lines: [
              Riskified::Entities::ShippingLine.new(
                  title: 'Free Shipping',
                  price: '0.0',
              )
          ],
          customer: Riskified::Entities::Customer.new(
              email: email,
              verified_email: true,
              first_name: 'Jone',
              last_name: 'Doe',
              id: 'C123',
              created_at: Time.now,
          ),
          client_details: Riskified::Entities::ClientDetails.new(
              accept_language: 'en-CA',
              user_agent: 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)',
          ),
          billing_address: Riskified::Entities::Address.new(
              first_name: 'Jone',
              last_name: 'Doe',
              address1: 'Chestnut Street 92',
              country: 'United States',
              city: 'Louisville',
              zip: '40202',
              phone: '555-625-1199',
          ),
          shipping_address: Riskified::Entities::Address.new(
              first_name: 'Jone',
              last_name: 'Doe',
              address1: 'Chestnut Street 92',
              country: 'United States',
              city: 'Louisville',
              zip: '40202',
              phone: '555-625-1199',
          ),
      )
    end

    before(:each) do |test|
      configure_riskified unless test.metadata[:skip_configuration]

      @client = Riskified::Client.new
    end

    context 'when missing connector configuration' do
      let(:order) {build_order(nil, 'will-not-reach-the-server@anyway.com')}
      it "it gets no order root key", :skip_configuration do
        expect {@client.decide(order)}.to(raise_error(Riskified::Exceptions::ConfigurationError))
      end
    end

    context 'when missing one configuration variable' do
      let(:order) {build_order(nil, 'will-not-reach-the-server@anyway.com')}
      it "it gets no order root key", :skip_configuration do
        Riskified.configure do |config|
          config.auth_token = nil
          config.default_referrer = 'whatever'
          config.shop_domain = 'whatever'
          config.sandbox_mode = true
        end

        expect {@client.decide(order)}.to(raise_error(Riskified::Exceptions::ConfigurationError))
      end
    end

    context 'when calling Decide' do

      def mock_decide_response(mocked_response_body, code = 200)
        response = Typhoeus::Response.new(code: code, body: mocked_response_body)
        Typhoeus.stub('https://sandbox.riskified.com/api/decide').and_return(response)
      end

      let(:shop_domain) {'www.recharge.com'}

      let(:order_id) do
        'CG-Test-R-' + ((SecureRandom.random_number(9e5) + 1e8).to_i).to_s
      end

      context 'with sync flow' do
        # must mock the response to avoid sending http requests
        before(:each) {mock_decide_response(mocked_response_body, mocked_response_code)}

        context 'when missing order id' do
          let(:mocked_response_body) {'{"error":{"message":"JSON malformed - no id key for order"}}'}
          let(:mocked_response_code) {400}
          let(:order) {build_order(nil, 'will-not-reach-the-server@anyway.com')}
          it "it gets no order root key" do
            expect {@client.decide(order)}.to(raise_error(Riskified::Exceptions::RequestFailed))
          end
        end

        context 'when missing order root key' do
          let(:mocked_response_body) {'{"error":{"message":"JSON malformed - no order root key"}}'}
          let(:mocked_response_code) {400}
          let(:order) {build_order(order_id, 'will-not-reach-the-server@anyway.com')}
          it "it gets no order root key" do
            # remove the order root key from the json object
            allow(order).to(receive(:convert_to_json)).and_return('{"id":"CG-Test-error","email":"will-not-reach-the-server@anyway.com","created_at":"2019-04-10 17:53:38 +0200","currency":"USD","gateway":"authorize_net","browser_ip":"111.111.111.111","total_price":26.49,"total_discounts":0.0,"referring_site":"cg.nl","customer":{"email":"will-not-reach-the-server@anyway.com","verified_email":true,"first_name":"Jone","last_name":"Doe","id":"C123","created_at":"2019-04-10 17:53:38 +0200","social":null,"verified_email_at":null,"first_purchase_at":null,"orders_count":null,"account_type":null,"phone":null,"verified_phone":null,"verified_phone_at":null,"date_of_birth":null,"user_name":null,"phone_mandatory":null,"referrer_customer_id":null,"social_signup_type":null,"gender":null},"client_details":{"accept_language":"en-CA","user_agent":"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"},"billing_address":{"first_name":"Jone","last_name":"Doe","address1":"Chestnut Street 92","country":"United States","city":"Louisville","zip":"40202","phone":"555-625-1199","address2":null,"company":null,"province":null,"province_code":null,"country_code":null,"additional_phone":null},"shipping_address":{"first_name":"Jone","last_name":"Doe","address1":"Chestnut Street 92","country":"United States","city":"Louisville","zip":"40202","phone":"555-625-1199","address2":null,"company":null,"province":null,"province_code":null,"country_code":null,"additional_phone":null},"line_items":[{"price":9.99,"quantity":1,"title":"Apple Gift Card","product_id":"P123","category":"Cards","brand":"Apple","product_type":null,"seller":null,"requires_shippling":null,"sku":null,"size":null,"condition":null,"sub_category":null,"delivered_at":null,"delivered_to":null},{"price":18.5,"quantity":1,"title":"Google Gift Card","product_id":"P456","category":"Cards","brand":"Google","product_type":null,"seller":null,"requires_shippling":null,"sku":null,"size":null,"condition":null,"sub_category":null,"delivered_at":null,"delivered_to":null}],"discount_codes":[{"amount":"2.0","code":"two-two"}],"shipping_lines":[{"title":"Free Shipping","price":"0.0","code":null,"company":null}],"source":"web","checkout_id":null,"vendor_id":null,"vendor_name":null,"order_type":null,"name":null,"updated_at":null,"cart_token":null,"note":null,"payment_details":null,"passengers":null,"decision":null,"charge_free_payment_details":null,"cancel_reason":null,"submission_reason":null}')

            expect {@client.decide(order)}.to(raise_error(Riskified::Exceptions::RequestFailed))
          end
        end

        context 'when order is fraud' do
          let(:mocked_response_body) {"{\"order\":{\"id\":\"#{order_id}\",\"status\":\"declined\",\"description\":\"Orderexhibitsstrongfraudulentindicators\",\"category\":\"Fraudulent\"}}"}
          let(:mocked_response_code) {200}
          let(:order) {build_order(order_id, 'test@decline.com')}
          it "gets declined response" do
            response_object = @client.decide(order)

            expect(response_object.to_string).to(eq("declined"))
          end
        end

        context 'when order is not fraud' do
          let(:mocked_response_body) {"{\"order\":{\"id\":\"#{order_id}\",\"status\":\"approved\",\"description\":\"Reviewed and approved by Riskified\"}}"}
          let(:mocked_response_code) {200}
          let(:order) {build_order(order_id, 'test@approve.com')}
          it "gets approved response" do
            response_object = @client.decide(order)

            expect(response_object.to_string).to(eq("approved"))
          end
        end

      end
    end
  end
end
