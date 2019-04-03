require 'spec_helper'
require 'SecureRandom'
require 'byebug'

module Riskified
  describe 'Riskified Client' do
      
    before(:all) do
      Riskified.configure do |config|
        config.auth_token = ENV["RISKIFIED_AUTH_TOKEN"]
        config.default_referrer = ENV["RISKIFIED_DEFAULT_REFERRER"]
        config.shop_domain = ENV["RISKIFIED_SHOP_DOMAIN"]
        config.sandbox_mode = true
      end
      
      @client = Riskified::Client.new
      @data = JSON.parse(File.read("#{File.dirname(__FILE__)}/../struct/order_example.json"))
    end
    
    before(:each) do
      @order_num = "CG" + ((SecureRandom.random_number(9e5) + 1e8).to_i).to_s
    end
    
    def configure_payload(payload)
      unless payload["id"]
        payload["order"]["id"] = @order_num
      else
        payload["id"] = @order_num
      end
      payload
    end

    context 'Submissions' do
      let(:order)              { {"order": configure_payload(@data["order"])} }
      let(:checkout)           { {"checkout": configure_payload(@data["order"])} }
      let(:refund)             { configure_payload(@data["refund"]) }
      let(:cancelled_order)    { configure_payload(@data["cancel"]) }
      
      
      it "Loads order data" do
        expect(@data).to be_an_instance_of(Hash)
      end
      
      it "Submits submit" do
        response = JSON.parse(@client.submit(order.to_json).body)
        expect(response["order"]).not_to be_falsey
      end

      it "Submits checkout create" do
        response = JSON.parse(@client.checkout_create(checkout.to_json).body)
        expect(response["checkout"]).not_to be_falsey
      end

      it "Submits checkout denied" do
        response = JSON.parse(@client.checkout_denied(checkout.to_json).body)
        expect(response["checkout"]).not_to be_falsey
      end
      
      it "Submits create" do
        response = JSON.parse(@client.create(order.to_json).body)
        expect(response["order"]).not_to be_falsey
      end
      
      it "Submits update" do
        response = JSON.parse(@client.update(order.to_json).body)
        expect(response["order"]).not_to be_falsey
      end

      it "Submits refund" do
        @client.create(order.to_json)
        response = JSON.parse(@client.refund(refund.to_json).body)
        expect(response["order"]).not_to be_falsey
      end
      
      it "Submits cancellation" do
        @client.create(order.to_json)
        response = JSON.parse(@client.cancel(cancelled_order.to_json).body)
        expect(response["order"]).not_to be_falsey
      end
      
    end
  end
end
