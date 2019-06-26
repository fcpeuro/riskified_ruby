require "riskified/version"
require 'riskified/configuration'
require 'riskified/request'
require 'riskified/response'
require 'riskified/client'
# Exceptions
require 'riskified/Exceptions/api_connection_error'
require 'riskified/Exceptions/configuration_error'
require 'riskified/Exceptions/request_failed_error'
require 'riskified/Exceptions/response_parsing_error'
require 'riskified/Exceptions/unexpected_order_status_error'
# Entities
require 'riskified/Entities/keyword_struct'
require 'riskified/Entities/address'
require 'riskified/Entities/client_details'
require 'riskified/Entities/customer'
require 'riskified/Entities/discount_code'
require 'riskified/Entities/line_item'
require 'riskified/Entities/order'
require 'riskified/Entities/shipping_line'
require 'riskified/Entities/recipient'
require 'riskified/Entities/paypal_details'
require 'riskified/Entities/credit_card_details'
require 'riskified/Entities/social'

module Riskified
  class << self
    attr_accessor :configuration
  end

  def self.config
    @configuration ||= Configuration.new
  end

  def self.validate_configuration
    raise Riskified::Exceptions::ConfigurationError.new('Connector not configured.') if @configuration.nil?

    @configuration.validate
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.client
    Client.new
  end

  def self.configure
    yield(config)
  end
end
