require 'spec_helper'
require 'byebug'

module Riskified
  describe 'Riskified::Client' do

    def configure_riskified
      Riskified.configure do |config|
        config.auth_token = '<<<< SHOP_AUTH_TOKEN_GOES_HERE >>>>' # Note: make sure you never commit your token.
        config.default_referrer = 'www.google.com'
        config.shop_domain = 'www.recharge.com'
        config.sandbox_mode = true
      end
    end

    let(:order) { build(:order) }

    before(:all) do
      @json_order = JSON.parse(File.read("#{File.dirname(__FILE__)}/../struct/order.json"))
    end

    before(:each) do |test|
      configure_riskified unless test.metadata[:skip_configuration]

      @client = Riskified::Client.new
    end

    context 'when missing connector configuration' do
      it "it raises ConfigurationError", :skip_configuration do
        expect {@client.decide(order)}.to(raise_error(Riskified::Exceptions::ConfigurationError))
      end
    end

    context 'when missing one configuration variable' do
      it "it raises ConfigurationError", :skip_configuration do
        Riskified.configure do |config|
          config.auth_token = nil
          config.default_referrer = 'whatever'
          config.shop_domain = 'whatever'
          config.sandbox_mode = true
        end

        expect {@client.decide(order)}.to(raise_error(Riskified::Exceptions::ConfigurationError))
      end
    end

    describe '.decide' do

      def mock_decision_response(mocked_response_body, code = 200)
        response = Typhoeus::Response.new(code: code, body: mocked_response_body)
        Typhoeus.stub('https://sandbox.riskified.com/api/decide').and_return(response)
      end

      let(:shop_domain) {'www.recharge.com'}

      context 'with sync flow' do
        # must mock the response to avoid sending http requests
        before(:each) {mock_decision_response(mocked_response_body, mocked_response_code)}

        context 'when missing order id' do
          let(:mocked_response_body) {'{"error":{"message":"JSON malformed - no id key for order"}}'}
          let(:mocked_response_code) {400}
          it "it raises RequestFailedError" do
            expect {@client.decide(order)}.to(raise_error(Riskified::Exceptions::RequestFailedError))
          end
        end

        context 'when missing order root key' do
          let(:mocked_response_body) {'{"error":{"message":"JSON malformed - no order root key"}}'}
          let(:mocked_response_code) {400}
          it "it raises RequestFailedError" do
            # remove the order root key from the json object
            allow(order).to(receive(:convert_to_json)).and_return('@json_order')

            expect {@client.decide(order)}.to(raise_error(Riskified::Exceptions::RequestFailedError))
          end
        end

        context 'when connection is down' do
          let(:mocked_response_body) {'{"error":{"message":"bla bla bla"}}'}
          let(:mocked_response_code) {0}
          it "it raises RequestFailedError" do
            # remove the order root key from the json object
            allow(order).to(receive(:convert_to_json)).and_return('@json_order')

            expect {@client.decide(order)}.to(raise_error(Riskified::Exceptions::ApiConnectionError))
          end
        end

        context 'when order is fraud' do
          let(:mocked_response_body) {"{\"order\":{\"id\":\"1\",\"status\":\"declined\",\"description\":\"Orderexhibitsstrongfraudulentindicators\",\"category\":\"Fraudulent\"}}"}
          let(:mocked_response_code) {200}
          it "gets declined response" do
            order.email = 'test@decline.com'
            response_object = @client.decide(order)

            expect(response_object.extract_order_status).to(eq("declined"))
          end
        end

        context 'when order is not fraud' do
          let(:mocked_response_body) {"{\"order\":{\"id\":\"2\",\"status\":\"approved\",\"description\":\"Reviewed and approved by Riskified\"}}"}
          let(:mocked_response_code) {200}
          it "gets approved response" do
            order.email = 'test@approve.com'
            response_object = @client.decide(order)

            expect(response_object.extract_order_status).to(eq("approved"))
          end
        end

      end
    end
  end
end
