require 'spec_helper'
require 'securerandom'
require 'byebug'

module Riskified
  describe 'Riskified Client' do

    def configure_riskified
      Riskified.configure do |config|
        config.auth_token = ENV["RISKIFIED_AUTH_TOKEN"]
        config.default_referrer = ENV["RISKIFIED_DEFAULT_REFERRER"]
        config.shop_domain = ENV["RISKIFIED_SHOP_DOMAIN"]
        config.sandbox_mode = true
      end
    end

    before(:all) do
      configure_riskified

      @client = Riskified::Client.new
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

    context 'when calling Decide' do

      def mock_decide_response(mocked_response_body, code = 200)
        response = Typhoeus::Response.new(code: code, body: mocked_response_body)
        Typhoeus.stub('https://sandbox.riskified.com/api/decide').and_return(response)
      end

      let(:order_id) do
        'CG-Test-CCC-' + ((SecureRandom.random_number(9e5) + 1e8).to_i).to_s
      end

      context 'with sync flow' do
        # must mock the response to avoid sending http requests
        before(:each) {mock_decide_response mocked_response_body, mocked_response_code}

        context 'when missing order id' do
          let(:mocked_response_body) {'{"error":{"message":"JSON malformed - no id key for order"}}'}
          let(:mocked_response_code) {400}
          let(:order) {build_order nil, 'will-not-reach-the-server@anyway.com'}
          it "it gets no order root key" do
            expect {@client.decide(order)}.to raise_error(Riskified::Exceptions::RequestFailed)
          end
        end

        context 'when missing order root key' do
          let(:mocked_response_body) {'{"error":{"message":"JSON malformed - no order root key"}}'}
          let(:mocked_response_code) {400}
          let(:order) {build_order order_id, 'will-not-reach-the-server@anyway.com'}
          it "it gets no order root key" do
            expect {@client.decide(order)}.to raise_error(Riskified::Exceptions::RequestFailed)
          end
        end

        context 'when order is fraud' do
          let(:mocked_response_body) {"{\"order\":{\"id\":\"#{order_id}\",\"status\":\"declined\",\"description\":\"Orderexhibitsstrongfraudulentindicators\",\"category\":\"Fraudulent\"}}"}
          let(:mocked_response_code) {200}
          let(:order) {build_order order_id, 'test@decline.com'}
          it "gets declined response" do
            response_object = @client.decide(order)

            expect(response_object.to_string).to eq "declined"
          end
        end

        context 'when order is not fraud' do
          let(:mocked_response_body) {"{\"order\":{\"id\":\"#{order_id}\",\"status\":\"approved\",\"description\":\"Reviewed and approved by Riskified\"}}"}
          let(:mocked_response_code) {200}
          let(:order) {build_order order_id, 'test@approve.com'}
          it "gets approved response" do
            response_object = @client.decide(order)

            expect(response_object.to_string).to eq "approved"
          end
        end

      end
    end
  end
end
